#!/bin/bash

# Apply node-exporter for system metrics
kubectl apply -f monitoring/node-exporter.yaml

# Add annotations to RC Car deployment for Prometheus scraping
kubectl patch deployment rc-car-landing -p '{"spec":{"template":{"metadata":{"annotations":{"prometheus.io/scrape":"true","prometheus.io/port":"3000","prometheus.io/path":"/metrics"}}}}}'

# Apply kube-state-metrics for Kubernetes state metrics
kubectl apply -f monitoring/kube-state-metrics.yaml

# Apply Grafana dashboards config
kubectl apply -f monitoring/grafana-dashboards-config.yaml

# Apply Grafana dashboard for pods
kubectl apply -f monitoring/grafana-dashboard-configmap.yaml

# Update Prometheus config to scrape annotated pods
kubectl apply -f monitoring/prometheus-config-update.yaml

# Restart Prometheus to apply new config
kubectl rollout restart deployment prometheus

# Wait for Prometheus to restart
echo "Waiting for Prometheus to restart..."
sleep 5

# Update Grafana deployment to mount dashboards
kubectl patch deployment grafana --patch '{"spec":{"template":{"spec":{"volumes":[{"name":"grafana-dashboards","configMap":{"name":"grafana-dashboards"}},{"name":"grafana-dashboard-pods","configMap":{"name":"grafana-dashboard-pods"}}],"containers":[{"name":"grafana","volumeMounts":[{"mountPath":"/etc/grafana/provisioning/dashboards","name":"grafana-dashboards"},{"mountPath":"/var/lib/grafana/dashboards","name":"grafana-dashboard-pods"}]}]}}}}'

# Restart Grafana to apply changes
kubectl rollout restart deployment grafana

echo "Pod monitoring setup complete!"
echo "Run these commands in separate terminals to get access URLs:"
echo "minikube service prometheus --url"
echo "minikube service grafana --url"

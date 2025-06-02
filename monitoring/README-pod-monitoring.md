# Kubernetes Pod Monitoring Setup

This directory contains configuration files for setting up comprehensive monitoring of Kubernetes pods for the RC Car Landing Page application.

## Components

### Node Exporter
- Collects system-level metrics from each node
- Runs as a DaemonSet to ensure coverage on all nodes
- Exposes metrics on port 9100

### Kube State Metrics
- Provides metrics about the state of Kubernetes objects
- Generates metrics about pods, deployments, nodes, etc.
- Essential for monitoring pod health and status

### Prometheus Configuration
- Updated to scrape metrics from annotated pods
- Configured to collect metrics from Node Exporter and Kube State Metrics
- Provides time-series storage for all metrics

### Grafana Dashboards
- Pre-configured dashboard for RC Car Landing Page pods
- Shows CPU usage, memory usage, pod restarts, and availability
- Automatically provisioned via ConfigMaps

## Setup Instructions

1. Run the setup script:
   ```bash
   ./monitoring/setup-pod-monitoring.sh
   ```

2. Access the dashboards:
   ```bash
   # In separate terminals
   minikube service prometheus --url
   minikube service grafana --url
   ```

3. Log in to Grafana:
   - Username: admin
   - Password: admin123
   - The RC Car Landing Page dashboard should be automatically available

## Metrics Available

- **Pod CPU Usage**: Rate of CPU consumption by each pod
- **Pod Memory Usage**: Memory consumption by each pod
- **Pod Restarts**: Number of container restarts
- **Pod Availability**: Percentage of pods in Running state

## Troubleshooting

If metrics are not showing up:

1. Check if pods have the correct annotations:
   ```bash
   kubectl get pods -l app=rc-car-landing -o jsonpath='{.items[*].metadata.annotations}'
   ```

2. Verify Prometheus is scraping the targets:
   - Access Prometheus UI
   - Go to Status > Targets
   - Check if all endpoints are "UP"

3. Restart the monitoring components if needed:
   ```bash
   kubectl rollout restart deployment prometheus
   kubectl rollout restart deployment grafana
   ```

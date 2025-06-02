# Monitoring and Security Setup for RC Car Landing Page

This directory contains configuration files for setting up monitoring and security scanning for the RC Car Landing Page application.

## Components

### Prometheus
- Metrics collection and storage
- Configured to scrape metrics from Kubernetes pods and the RC Car application
- Accessible at http://localhost:30900 when deployed

### Grafana
- Visualization and dashboards for metrics
- Pre-configured with admin credentials (username: admin, password: admin123)
- Accessible at http://localhost:30300 when deployed

### Trivy
- Container vulnerability scanner
- Configured to run as a daily CronJob in Kubernetes
- Also integrated into the Jenkins pipeline for CI/CD security checks

## Deployment Instructions



### Deploy Prometheus and Grafana

```bash
# Apply Prometheus configurations
kubectl apply -f monitoring/prometheus-config.yaml
kubectl apply -f monitoring/prometheus-deployment.yaml
kubectl apply -f monitoring/prometheus-service.yaml

# Apply Grafana configurations
kubectl apply -f monitoring/grafana-deployment.yaml
kubectl apply -f monitoring/grafana-service.yaml

# Deploy Trivy CronJob for regular scanning
kubectl apply -f monitoring/trivy-scan.yaml
```

### Accessing the Dashboards

- Prometheus: http://localhost:30900
- Grafana: http://localhost:30300

### Initial Grafana Setup

1. Log in with admin/admin123
2. Add Prometheus as a data source:
   - URL: http://prometheus:9090
   - Access: Server (default)
3. Import dashboards:
   - Node Exporter dashboard (ID: 1860)
   - Kubernetes cluster monitoring dashboard (ID: 315)

## Security Scanning

The Trivy security scanner is configured to:
1. Run daily as a Kubernetes CronJob
2. Execute during the Jenkins pipeline build process
3. Scan for HIGH and CRITICAL vulnerabilities

To run a manual scan:

```bash
./monitoring/trivy-ci.sh
```

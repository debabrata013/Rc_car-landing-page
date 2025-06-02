#!/bin/bash

# Install Trivy if not already installed
if ! command -v trivy &> /dev/null; then
    echo "Installing Trivy..."
    brew install aquasecurity/trivy/trivy
fi

# Scan the Docker image for vulnerabilities
echo "Scanning Docker image for vulnerabilities..."
trivy image --severity HIGH,CRITICAL rc-landing:latest

# Exit with error if critical vulnerabilities are found
if [ $? -ne 0 ]; then
    echo "Critical vulnerabilities found in the Docker image!"
    exit 1
fi

echo "Security scan completed successfully."
exit 0

#!/bin/bash

# Get the service URL
SERVICE_URL=$(minikube service rc-car-landing-service --url)

echo "Starting load test on $SERVICE_URL"
echo "Press Ctrl+C to stop"

# Function to make requests
make_requests() {
  while true; do
    curl -s "$SERVICE_URL" > /dev/null
    curl -s "$SERVICE_URL/metrics" > /dev/null
    sleep 0.1
  done
}

# Start multiple request processes
for i in {1..5}; do
  make_requests &
done

# Wait for user to stop
wait

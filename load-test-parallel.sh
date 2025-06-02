#!/bin/bash

# Port-forward the service to a local port
kubectl port-forward svc/rc-car-landing-service 3000:80 &
PORT_FORWARD_PID=$!

# Wait for port-forwarding to be established
sleep 2

echo "Starting load test on http://localhost:3000"
echo "Press Ctrl+C to stop"

# Function to make requests
make_requests() {
  local id=$1
  local count=0
  while true; do
    curl -s "http://localhost:3000/" > /dev/null
    curl -s "http://localhost:3000/metrics" > /dev/null
    count=$((count+1))
    if [ $((count % 10)) -eq 0 ]; then
      echo "Process $id: $count requests made"
    fi
    sleep 0.05
  done
}

# Start multiple request processes
for i in {1..10}; do
  make_requests $i &
  PIDS+=($!)
done

# Trap Ctrl+C to clean up
trap 'echo "Stopping load test..."; kill ${PIDS[@]} $PORT_FORWARD_PID 2>/dev/null; exit' INT

# Wait for user to stop
wait

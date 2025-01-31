#!/bin/bash
set -e

# Configuration
PROJECT_ROOT=$(pwd)
HAPROXY_CFG="$PROJECT_ROOT/haproxy.cfg"
JAR_FILE="$PROJECT_ROOT/target/grpc-haproxy-1.0-SNAPSHOT.jar"

# Function to cleanup background processes
cleanup() {
    echo "Cleaning up..."
    sudo pkill haproxy || true
}
trap cleanup EXIT SIGINT

# Ensure the jar file exists
if [ ! -f "$JAR_FILE" ]; then
    echo "Jar file not found. Building the project..."
    mvn clean install
fi

# Start HAProxy
echo "Starting HAProxy..."
sudo haproxy -f $HAPROXY_CFG -d &
wait


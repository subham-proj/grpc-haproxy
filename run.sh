#!/bin/bash
set -e

# Configuration
PROJECT_ROOT=$(pwd)
HAPROXY_CFG="$PROJECT_ROOT/haproxy.cfg"
NUMBER_OF_SERVERS=2
SERVER_PORTS=(8080 8081)
CLIENT_REQUESTS=5

# Build the project
echo "Building project..."
mvn clean install

# Function to cleanup background processes
cleanup() {
    echo "Cleaning up..."
    pkill -f GrpcServer || true
    sudo pkill haproxy || true
}
trap cleanup EXIT SIGINT

# Start HAProxy
echo "Starting HAProxy..."
sudo haproxy -f $HAPROXY_CFG -d &

# Start multiple gRPC servers
echo "Starting gRPC servers..."
for i in $(seq 0 $(($NUMBER_OF_SERVERS - 1))); do
    PORT=${SERVER_PORTS[$i]}
    SERVER_ID=$((i+1))
    echo "Starting server $SERVER_ID on port $PORT"
    mvn -pl server exec:java -Dexec.mainClass="com.example.GrpcServer" \
        -Dexec.args="$PORT" -Dserver.id=$SERVER_ID &
    sleep 1 # Give some time between server starts
done

# Wait for servers to start
echo "Waiting for servers to initialize..."
sleep 5

# Run client
echo "Running client with $CLIENT_REQUESTS requests..."
mvn -pl client exec:java -Dexec.mainClass="com.example.GrpcClient" \
    -Dexec.args="$CLIENT_REQUESTS"

# Keep running until interrupted
echo "Demo is running... Press Ctrl+C to stop"
wait
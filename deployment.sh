#!/bin/bash
set -e

CLUSTER_NAME="python-calculator"
IMAGE_NAME="python-calculator:latest"

echo "🚀 Deploying Python Calculator to Kind"

# Check if cluster exists, create if not
if ! kind get clusters | grep -q "^${CLUSTER_NAME}$"; then
    echo "Creating Kind cluster with configuration..."
    kind create cluster --name ${CLUSTER_NAME} --config=kind-cluster-config.yaml
else
    echo "Using existing Kind cluster: ${CLUSTER_NAME}"
fi

# Build and load image
echo "Building Docker image..."
docker build -t ${IMAGE_NAME} .

echo "Loading image into Kind cluster..."
kind load docker-image ${IMAGE_NAME} --name ${CLUSTER_NAME}

# Deploy to Kubernetes
echo "Deploying to Kubernetes..."
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# Wait for deployment
echo "Waiting for deployment to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/python-calculator

# Show status
echo ""
echo "✅ Deployment complete!"
kubectl get pods -l app=python-calculator
kubectl get services

echo ""
echo "🌐 Your application is available at:"
echo "   http://localhost:30080/"
echo ""
echo "Test endpoints:"
echo "   curl http://localhost:30080/health"
echo "   curl http://localhost:30080/add/5/3"
echo "   curl http://localhost:30080/sub/10/4"

# Health endpoint validation
echo ""
echo "Validating /health endpoint..."
if curl --fail --silent http://localhost:30080/health; then
    echo "✅ /health endpoint is healthy!"
else
    echo "❌ /health endpoint check failed!"
    exit 1
fi
# Add endpoint validation (5 + 3 = 8)
echo "Testing /add/5/3 endpoint (expecting 8)..."
ADD_RESPONSE=$(curl --fail --silent http://localhost:30080/add/5/3)
echo "Add response: $ADD_RESPONSE"
if [[ "$ADD_RESPONSE" == *"8"* ]]; then
    echo "✅ /add endpoint is working correctly!"
else
    echo "❌ /add endpoint failed! Expected 8 in response but got: $ADD_RESPONSE"
    exit 1
fi

# Subtract endpoint validation (10 - 4 = 6)
echo "Testing /sub/10/4 endpoint (expecting 6)..."
SUB_RESPONSE=$(curl --fail --silent http://localhost:30080/sub/10/4)
echo "Sub response: $SUB_RESPONSE"
if [[ "$SUB_RESPONSE" == *"6"* ]]; then
    echo "✅ /sub endpoint is working correctly!"
else
    echo "❌ /sub endpoint failed! Expected 6 in response but got: $SUB_RESPONSE"
    exit 1
fi
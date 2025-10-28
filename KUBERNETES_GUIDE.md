# Docker Desktop Kubernetes Deployment Guide

This guide explains how to use Docker Desktop to deploy a Kubernetes application with a simple Python example.

## Prerequisites

1. **Docker Desktop** installed and running
2. **Kubernetes enabled** in Docker Desktop:
   - Open Docker Desktop → Settings → Kubernetes
   - Check "Enable Kubernetes"
   - Click "Apply & Restart"

## Project Structure
```
githubActions/
├── app.py              # Flask web application
├── main.py             # Core functions
├── requirements.txt    # Python dependencies
├── Dockerfile          # Container definition
├── k8s/
│   ├── deployment.yaml # Kubernetes deployment
│   └── service.yaml    # Kubernetes service
└── README.md
```

## Step-by-Step Deployment

### 1. Build Docker Image
```bash
# Navigate to project directory
cd githubActions

# Build the Docker image
docker build -t python-calculator:latest .

# Verify image was created
docker images | grep python-calculator
```

### 2. Test Docker Image Locally (Optional)
```bash
# Run container locally to test
docker run -p 5000:5000 python-calculator:latest

# Test endpoints
curl http://localhost:5000/
curl http://localhost:5000/add/5/3
curl http://localhost:5000/health
```

### 3. Deploy to Kubernetes
```bash
# Apply deployment and service
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# Check deployment status
kubectl get deployments
kubectl get pods
kubectl get services
```

### 4. Access Your Application
```bash
# Get service URL (Docker Desktop)
kubectl get service python-calculator-service

# Access via localhost (Docker Desktop automatically maps)
curl http://localhost:30080/
curl http://localhost:30080/add/10/5
```

## API Endpoints

- `GET /` - Welcome message
- `GET /add/{a}/{b}` - Add two numbers
- `GET /sub/{a}/{b}` - Subtract two numbers  
- `GET /health` - Health check

## Kubernetes Components Explained

### Deployment (`deployment.yaml`)
- **Replicas**: 2 instances for high availability
- **Health Checks**: Liveness and readiness probes
- **Resource Limits**: CPU and memory constraints
- **Image**: Uses locally built `python-calculator:latest`

### Service (`service.yaml`)
- **Type**: LoadBalancer (works with Docker Desktop)
- **Port Mapping**: External port 80 → Container port 5000
- **NodePort**: 30080 for direct access

## Useful Commands

```bash
# View logs
kubectl logs -l app=python-calculator

# Scale deployment
kubectl scale deployment python-calculator --replicas=3

# Delete resources
kubectl delete -f k8s/

# Access pod directly
kubectl port-forward deployment/python-calculator 8080:5000
```

## Troubleshooting

1. **Image not found**: Ensure Docker image is built locally
2. **Pods not starting**: Check `kubectl describe pod <pod-name>`
3. **Service not accessible**: Verify Docker Desktop Kubernetes is enabled
4. **Port conflicts**: Change nodePort in service.yaml

## Next Steps

- Add persistent storage with PersistentVolumes
- Implement ConfigMaps and Secrets
- Add ingress controller for advanced routing
- Set up monitoring with Prometheus
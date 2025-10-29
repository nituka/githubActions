# Python GitHub Actions Demo


This is a simple Python project demonstrating automated CI/CD using GitHub Actions and Kubernetes deployment with Kind.

## Project Structure
- [`main.py`](main.py): Core calculation functions
- [`app.py`](app.py): Flask web API
- [`test_main.py`](test_main.py): Unit tests
- [`Dockerfile`](Dockerfile): Container definition
- [`kind-cluster-config.yaml`](kind-cluster-config.yaml): Kind cluster configuration
- [`deployment.sh`](deployment.sh): Local deployment script
- [`k8s/`](k8s/): Kubernetes manifests
- [`.github/workflows/complete-cicd.yml`](.github/workflows/complete-cicd.yml): Automated CI/CD pipeline

## Features
✅ **Automated Testing** - Unit tests run on every push/PR  
✅ **Automated Building** - Docker images built automatically  
✅ **Automated Deployment** - Deploys to Kind cluster in GitHub Actions  
✅ **Health Checks** - API endpoints validated after deployment  

## API Endpoints
- `GET /` - Welcome message  
- `GET /add/{a}/{b}` - Add two numbers
- `GET /sub/{a}/{b}` - Subtract two numbers
- `GET /health` - Health check

## Local Development

### Run Locally
```bash
python app.py
python -m unittest test_main.py
```

### Deploy to Kind Locally
```bash
# Make deployment script executable
chmod +x deployment.sh

# Deploy everything
./deployment.sh

# Test endpoints
curl http://localhost:30080/health
curl http://localhost:30080/add/5/3
```

## Automated CI/CD Pipeline

The GitHub Actions workflow automatically:

1. **On Push/PR**: 
   - Runs unit tests using [`test_main.py`](test_main.py)
   - Validates code quality

2. **On Push to main/test**:
   - Builds Docker image from [`Dockerfile`](Dockerfile)
   - Creates Kind cluster using [`kind-cluster-config.yaml`](kind-cluster-config.yaml)
   - Deploys using [`k8s/deployment.yaml`](k8s/deployment.yaml) and [`k8s/service.yaml`](k8s/service.yaml)
   - Runs API validation tests
   - Reports deployment status


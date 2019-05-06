# Simple api server based on my py-openapi2-example repo
A skeleton OpenApi v2 interface and service.  Useful for using with Google Endpoints. 

# Prerequisites
Install VSCode 

# Installation
```
export PIPENV_VENV_IN_PROJECT=1
pipenv install --three
```

# Local execution
```
./service.py
```

# Build and run
```
docker build .
docker run -p 9000:9000 -e PORT=9000 imageid
```

# Local endpoints
OpenAPI
```
curl http://0.0.0.0:8080/api/ui
```

```
# Helloworld
curl http://0.0.0.0:8080/api/
curl http://0.0.0.0:8080/api/health
```

# Configure Remote Debugging 
Use gcloud to configure kubectl credentials

```
gcloud container clusters get-credentials servicebroker --zone europe-west2-a --project tipinfra-01
```

```
export PIPENV_VENV_IN_PROJECT=1
pipenv install 
```

# Getting Started (create .env)
Create a .env file and add some values to it.
```
# This is for local docker debugging 
export DEBUGGER=True
export WAIT=True
```


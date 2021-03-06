# README.md
This repo demonstrates standing up a GCP project using the SDK first. 
Then allowing you to use a created service account within the project to deploy resources in Terraform.

The example service that will be deployed into the project is a python helloworld container using endpoint and an NLB.  

* Deploy a simple instance group with one container running the simple_api_server
* Add an Google Endpoint to it.  
* Add a simple NLB
* Add the SSL certificate

# NOTES:
It uses - GCP, SSL certificates, NLB, Docker, Python, Swagger, API Endpoints and GCE VM's.  A GKE version will be coming soon.

This could have been achieved with a serverless solution and this would have had its merits. However, I thought I'd create an interesting exercise.  

* The API endpoint will return "hello world"
curl http://cntfdemo.endpoints.simple-terraform-guestdemo-001.cloud.goog/api/helloworld\?key\=[key]

* It uses an API key as part of the endpoints simple auth.  The idea is that this allow rate limiting and all the goodness of a API gateway.
curl https://cntfdemo.guestcode.uk/api/helloworld\?key=[key]

* There is also a health endpoint. 
curl http://cntfdemo.endpoints.simple-terraform-guestdemo-001.cloud.goog/api/health\?key\=[key]

* There is also a registered subdomain. cntfdemo.guestcode.uk.  However, there is some slight misconfiguration that needs addressing.  This is where I have run out of time.  
curl https://cntfdemo.guestcode.uk/api/helloworld\?key=[key]



# TODO:
Fix some of the issues:
* Api needs enabling manually
    gcloud --project simple-terraform-guestdemo-001 services enable cntfdemo.endpoints.simple-terraform-guestdemo-001.cloud.goog
* The Ip address passed to the openapi schema is incorrect.  You'll need to modify the schema target ip to the external ip of the instance or NLB
    gcloud --project=simple-terraform-demo-001 endpoints services deploy ./simple_api_server/openapi/service_api.template.fix.yaml
* The container should be using gunicorn to host flask.
* The NLB backend seems to be incorrectly configured.  It's not pointing correctly after deployment.


# Prerequisites
* A GCP account
* Terraform
* GoogleCloud SDK

# Switch to the correct configuration 
Make sure you switch to the correct configuration before deploying.
```
gcloud config configurations activate <configname>
```

# Configuring 
Copy .env.sh.template to .env.sh and fill out the values.

Overriding Terraform environment with your own values. 
```
export PROJECT_ID="simple-terraform-demo-001"
export PROJECT_NAME=${PROJECT_ID}
export GOOGLE_CLOUD_KEYFILE_JSON=$(pwd)/manual-terraform-sa-${PROJECT_ID}.json

export TF_VAR_region_a="europe-west1"
export TF_VAR_region_a_zone="europe-west1-c"
export TF_VAR_project_name=${PROJECT_ID}
export TF_VAR_project_id=${PROJECT_ID}
export TF_VAR_keyfile=${GOOGLE_CLOUD_KEYFILE_JSON}
export TF_VAR_endpoint_name="cntfdemo"
export TF_VAR_domain_name="domain.uk"

# gcloud organizations list
export ORGANIZATION_ID=

# gcloud beta billing accounts list
export BILLING_ACCOUNT=

# Manually create an API key in the console
export ENDPOINTS_KEY=<key>
```

# Deploying
Prepare.
```
. ./.env.sh
./create_project.sh
terraform init
terraform plan
```

Deploy the resources 
```
. ./.env.sh
terraform apply
```

# Testing 
Test the endpoints with the following 
```
. ./.env.sh
./quick_test.sh
```

# Taking it down

```
terraform destroy
```


# Troubleshooting
During deployment you can improve the trace logging from Terraform

```
export TF_LOG=DEBUG
```

The certificate can take a long time to propagate on the cloud load balancers.  
Use the ./quick_test.sh shell command

```
watch -n 10 ./quick_test.sh
```

Using it too many times on some accounts may have restricted quotas on global static ip. 
For this you'll either have to increase the quota or remove a current ip.

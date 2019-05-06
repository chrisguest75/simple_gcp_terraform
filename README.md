# README.md
This repo demonstrates standing up a GCP project using the SDK first. 
Then allowing you to use a created service account within the project to deploy resources in Terraform.

The example service that will be deployed into the project is a python helloworld container using endpoint and an NLB.  

* Deploy a simple instance group with one container running the simple_api_server
* Add an Google Endpoint to it.  
* Add a simple NLB
* Add the SSL certificate

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

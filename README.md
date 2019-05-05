# README.md
This repo demonstrates standing up a project using the SDK first. 

* Deploy a simple instance group with one container running
* Add a simple NLB
* Add the SSL certificate

# Prerequisites
* A GCP account
* Terraform
* GoogleCloud SDK

# Configuring 
Copy .env.sh.template to .env.sh and fill out the values.

Overriding Terraform environment with the following.
```
export TF_VAR_region_a_zone="europe-west1-c"
export TF_VAR_project_id=${PROJECT_ID}
export TF_VAR_keyfile=${GOOGLE_CLOUD_KEYFILE_JSON}
```

# Deploying
```
. ./.env.sh
./create_project.sh
terraform init
```

# Taking it down

```
terraform destroy
```


# Troubleshooting

```
export TF_LOG=DEBUG
```
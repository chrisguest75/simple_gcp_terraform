# README.md
This repo demonstrates standing up a project using the SDK first. 

* Deploy a simple instance group with one container running
* Add a simple NLB
* Add the SSL certificate

```
export TF_LOG=DEBUG
```

# Starting 
Copy .env.template to .env and fill out the values.

```
./create_project.sh
terraform init
```

#!/usr/bin/env bash
set -eof pipefail

if [ -f ./.env.sh ];then
    . ./.env.sh
else
    echo "Environment file is not available"
    exit 1
fi

PROJECTS=$(gcloud projects list --format="table[no-heading](name)")
if [ $(echo "${PROJECTS}" | grep "${PROJECT_ID}") ]; then
    echo "${PROJECT_ID} already exists"
else
    gcloud projects create ${PROJECT_ID} --organization=${ORGANIZATION_ID} --name=${PROJECT_NAME}
fi

SERVICE_ACCOUNTS=$(gcloud --project ${PROJECT_ID} iam service-accounts list --format="table[no-heading](name)")
if [ $(echo "${SERVICE_ACCOUNTS}" | grep "manual-terraform") ]; then
    echo "manual-terraform already exists"
else
    gcloud --project ${PROJECT_ID} iam service-accounts create manual-terraform --display-name "manual-terraform-sa"
fi

if [ -f "manual-terraform-sa-${PROJECT_ID}.json" ]; then
    echo "manual-terraform-sa-${PROJECT_ID}.json already exists"
else
    gcloud --project ${PROJECT_ID} iam service-accounts keys create manual-terraform-sa-${PROJECT_ID}.json --iam-account manual-terraform@${PROJECT_ID}.iam.gserviceaccount.com
fi

gcloud --project=${PROJECT_ID} projects add-iam-policy-binding ${PROJECT_ID} --member="serviceAccount:manual-terraform@${PROJECT_ID}.iam.gserviceaccount.com" --role='roles/owner'

echo "NOTE: Billing is being enabled on the project ${PROJECT_ID}"
gcloud beta billing projects link ${PROJECT_ID} --billing-account=${BILLING_ACCOUNT}

gcloud --project=${PROJECT_ID} services enable servicemanagement.googleapis.com
gcloud --project=${PROJECT_ID} services enable compute.googleapis.com
gcloud --project=${PROJECT_ID} services enable cloudresourcemanager.googleapis.com
gcloud --project=${PROJECT_ID} services enable endpoints.googleapis.com


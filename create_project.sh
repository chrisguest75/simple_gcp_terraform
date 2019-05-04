#!/usr/bin/env bash
set -eof pipefail

. ./.env
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

if [ -f "manual-terraform-sa.json" ]; then
    echo "manual-terraform-sa.json already exists"
else
    gcloud --project ${PROJECT_ID} iam service-accounts keys create manual-terraform-sa.json --iam-account manual-terraform@simple-terraform-01.iam.gserviceaccount.com
fi

gcloud --project=${PROJECT_ID} projects add-iam-policy-binding ${PROJECT_ID} --member="serviceAccount:manual-terraform@simple-terraform-01.iam.gserviceaccount.com" --role='roles/owner'

gcloud --project=${PROJECT_ID} services enable servicemanagement.googleapis.com
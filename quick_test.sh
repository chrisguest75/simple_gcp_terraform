#!/usr/bin/env bash
. ./.env.sh

echo "*****************************************************************************"
echo "http://${TF_VAR_endpoint_name}.endpoints.${PROJECT_ID}.cloud.goog/api/health?key=${ENDPOINTS_KEY}"
echo "*****************************************************************************"

curl "http://${TF_VAR_endpoint_name}.endpoints.${PROJECT_ID}.cloud.goog/api/health?key=${ENDPOINTS_KEY}"
curl "http://${TF_VAR_endpoint_name}.endpoints.${PROJECT_ID}.cloud.goog/api/helloworld?key=${ENDPOINTS_KEY}"

echo "*****************************************************************************"
echo "https://${TF_VAR_endpoint_name}.${TF_VAR_domain_name}/api/health?key=${ENDPOINTS_KEY}"
echo "*****************************************************************************"

curl "https://${TF_VAR_endpoint_name}.${TF_VAR_domain_name}/api/health?key=${ENDPOINTS_KEY}"
curl "https://${TF_VAR_endpoint_name}.${TF_VAR_domain_name}/api/helloworld?key=${ENDPOINTS_KEY}"

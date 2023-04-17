#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

function az_login {
    # LOGIN TO AZURE
    az login --service-principal \
        --username=${ARM_CLIENT_ID} \
        --password=${ARM_CLIENT_SECRET} \
        --tenant=${ARM_TENANT_ID} >/dev/null 2>&1
    
    az account set -s ${ARM_SUBSCRIPTION_ID} >/dev/null 2>&1
}

function az_webapp_config_set() {
    az webapp config set \
        -g "test-app-rg" \
        -n "${WEBAPP_NAME}" \
        --vnet-route-all-enabled true
}

az_login
az_webapp_config_set
az logout || echo "Already logged out"
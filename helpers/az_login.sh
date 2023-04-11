#!/bin/bash

# Global Variables
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Includes
source "${SCRIPT_DIR}"/_helpers.sh

_information "Logging out of Azure..."
az logout || true 
_success "Logged out of Azure"

_information "Logging into Azure..."
az login --service-principal \
    --username=$ARM_CLIENT_ID \
    --password=$ARM_CLIENT_SECRET \
    --tenant $ARM_TENANT_ID
_success "Logged into Azure"

_information "Setting Azure Subscription..."
az account set -s $ARM_SUBSCRIPTION_ID
_information "Set Azure Subscription"

#!/bin/bash

set -e

# Global Variables
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Includes
source "${SCRIPT_DIR}"/_helpers.sh

read -p 'TENANT_ID: ' TENANT_ID
read -p 'SUBSCRIPTION_ID: ' SUBSCRIPTION_ID
read -p 'RESOURCE_GROUP: ' RESOURCE_GROUP
read -p 'STORAGE_ACCOUNT_LOCATION (uksouth): ' STORAGE_ACCOUNT_LOCATION
read -p 'STORAGE_ACCOUNT_NAME: ' STORAGE_ACCOUNT_NAME
read -p 'STORAGE_ACCOUNT_SKU (Standard_LRS): ' STORAGE_ACCOUNT_SKU
read -p 'STORAGE_CONTAINER_NAME: ' STORAGE_CONTAINER_NAME
read -p 'SERVICE_PRINCIPAL_NAME: ' SERVICE_PRINCIPAL_NAME
read -p 'TERRAFORM_STATE_NAME: ' TERRAFORM_STATE_NAME

_information "Creating JSON file for Azure account details..."
export az_account_details="$HOME/.az_details.json"
touch "${az_account_details}"
_success "Created JSON file for Azure account details"

_information "Prompting Login to Azure..."
az login --tenant $TENANT_ID | grep -v "Opening in existing browser session.">  "${az_account_details}" 
_success "Logged into Azure" 

_information "Setting Azure Subscription ID..."
az account set -s $SUBSCRIPTION_ID
_success "Set Azure Subscription ID"

_information "Creating Resource Group..."
az group create \
    --location "${STORAGE_ACCOUNT_LOCATION}" \
    --name "${RESOURCE_GROUP}"
_success "Created Resource Group"

_information "Creating Storage Account..."
az storage account create \
    --name "${STORAGE_ACCOUNT_NAME}" \
    --resource-group "${RESOURCE_GROUP}" \
    --location "${STORAGE_ACCOUNT_LOCATION}" \
    --sku "${STORAGE_ACCOUNT_SKU}"
_success "Created Storage Account"

_information "Creating Storage Account Container..."
az storage container create \
--name "${STORAGE_CONTAINER_NAME}" \
--account-name "${STORAGE_ACCOUNT_NAME}"
_success "Created Storage Account Container"

_information "----------------"
_information "Storage Account Key:"
storage_account_key=$(az storage account keys list \
    --account-name "${STORAGE_ACCOUNT_NAME}" \
    --query "[0].value" \
    -o tsv)
_information "----------------"

_information "Creating Service Principal..."
created_service_principal=$(az ad sp create-for-rbac \
    --name "${SERVICE_PRINCIPAL_NAME}" \
    --role Contributor \
    --scopes /subscriptions/"${SUBSCRIPTION_ID}")
created_app_id=$(echo $created_service_principal | jq -r '.appId')
created_password=$(echo $created_service_principal | jq -r '.password')
_success "Created Service Principal"

_information "----------------"
_information "For env.local.sh..."
echo "export ARM_CLIENT_ID=$created_app_id"
echo "export ARM_CLIENT_SECRET=$created_password"
echo "export ARM_TENANT_ID=$TENANT_ID"
echo "export ARM_SUBSCRIPTION_ID=$SUBSCRIPTION_ID"
echo "export ARM_ACCESS_KEY=$storage_account_key"
_information "----------------"

_information "----------------"
_information "For backend.tf"
cat << EndOfMessage
terraform {
  backend "azurerm" {
    resource_group_name  = "$RESOURCE_GROUP"
    storage_account_name = "$STORAGE_ACCOUNT_NAME"
    container_name       = "$STORAGE_CONTAINER_NAME"
    key                  = "$TERRAFORM_STATE_NAME"
  }
}
EndOfMessage
_information "----------------"

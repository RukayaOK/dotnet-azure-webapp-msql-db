#!/bin/bash

az group create \
    --name web-app-rg \
    --location uksouth


az network vnet create \
    --resource-group web-app-rg \
    --location uksouth \
    --name myWebVNet \
    --address-prefixes 10.1.0.0/16 \
    --subnet-name myBackendSubnet \
    --subnet-prefixes 10.1.0.0/24

az network vnet subnet update \
    --name myBackendSubnet \
    --resource-group web-app-rg \
    --vnet-name myWebVNet \
    --disable-private-endpoint-network-policies false

# remove reoute tables 

az network nsg create \
    -g web-app-rg \
    -n myBackendSubnetNsg

az network vnet subnet update \
    --resource-group web-app-rg \
    --vnet-name myWebVNet \
    --name myBackendSubnet \
    --network-security-group myBackendSubnetNsg

az network vnet subnet create \
    --resource-group web-app-rg \
    --name AzureWebApp \
    --vnet-name myWebVNet \
    --address-prefixes 10.1.1.0/24 \
    --service-endpoints Microsoft.Sql \
    --delegations Microsoft.Web/serverFarms


az network nsg create \
    -g web-app-rg \
    -n AzureWebAppNsg

az network vnet subnet update \
    --resource-group web-app-rg \
    --vnet-name myWebVNet \
    --name AzureWebApp \
    --network-security-group AzureWebAppNsg

### DATABASE ###

az sql server create \
    --name sqlserver123451 \
    --resource-group web-app-rg \
    --location uksouth \
    --admin-user sqladmin \
    --admin-password azpassword123!


az sql db create \
    --resource-group web-app-rg  \
    --server sqlserver123451 \
    --name myDataBase \
    --sample-name AdventureWorksLT


### PE ###
id=$(az sql server list \
    --resource-group web-app-rg  \
    --query '[].[id]' \
    --output tsv)

az network private-endpoint create \
    --name myPrivateEndpoint \
    --resource-group web-app-rg \
    --vnet-name myWebVNet \
    --subnet myBackendSubnet \
    --private-connection-resource-id $id \
    --group-ids sqlServer \
    --connection-name myConnection

az network private-dns zone create \
    --resource-group web-app-rg \
    --name "privatelink.database.windows.net"

az network private-dns link vnet create \
    --resource-group web-app-rg \
    --zone-name "privatelink.database.windows.net" \
    --name MyDNSLink \
    --virtual-network myWebVNet \
    --registration-enabled false

az network private-endpoint dns-zone-group create \
   --resource-group web-app-rg \
   --endpoint-name myPrivateEndpoint \
   --name MyZoneGroup \
   --private-dns-zone "privatelink.database.windows.net" \
   --zone-name sql

### WEBAPP ###

az appservice plan create \
    -g web-app-rg \
    -n MyWebAppPlan \
    --sku B1

az webapp create \
    -g web-app-rg \
    -p MyWebAppPlan \
    -n Mywebapp3682


az webapp vnet-integration add -g MyResourceGroup -n MyWebapp --vnet MyVnetName --subnet MySubnetName -s [slot]
# Create a new service principal

AAD_SP=$(az ad sp create-for-rbac)
CLIENT_ID=$(echo $AAD_SP | jq -r .appId)
CLIENT_SECRET=$(echo $AAD_SP | jq -r .password)
TENANT_ID=$(echo $AAD_SP | jq -r .tenant)
SUBSCRIPTION_ID=$(az account show --query id | tr -d '"')
LOCATION=$(echo $RG | jq -r .location)
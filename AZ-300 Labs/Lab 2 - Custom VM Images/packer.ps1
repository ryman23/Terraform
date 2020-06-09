# Packer Powershell Create Windows Image

# Get the Service Principal
$sp = Get-AzureADServicePrincipal -SearchString PackerServicePrincipal

# Gather details for the Packer configuration
$sp.applicationId.guid       | clip # client_id
$sp.id.guid                  | clip # object_id

# Get the subscription information
$subscription = Get-AzSubscription
$subscription.TenantId       | clip # tenent_id
$subscription.SubscriptionId | clip # subscription_id

# Get the resource group
Get-AzResourceGroup -Name MC-CustomImages-CUS

# Validate the Packer Image
C:\ProgramData\chocolatey\bin\packer.exe validate .\windows.json

# Create the Packer Image
C:\ProgramData\chocolatey\bin\packer.exe build .\windows.json

Clear-Host

# Create a VM with the Packer image
New-AzVM `
    -ResourceGroupName "MC-AZ900Labs-CUS" `
    -Name "Test-WindowsVM" `
    -Location "centralus" `
    -VirtualNetworkName "MC-VNET" `
    -SubnetName "Test" `
    -PublicIpAddressName "Test-PIP" `
    -Image "WindowsServer-PackerImage" `
    -Size "Standard_B2ms"
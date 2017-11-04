# Service Fabric and Server 1709 volumes demo

## Set up a cluster
```bash
az group create -n sf-1709 -l westus
az keyvault create -n sf-1709 -g sf-1709 --enabled-for-deployment --enabled-for-template-deployment

# Create a cert
az keyvault certificate create --vault-name sf-1709 -n sf-1709 -p "$(az keyvault certificate get-default-policy -o json)"

# parameters.json - certificateThumbprint
az keyvault certificate show -n sf-1709 --vault-name sf-1709 --query 'x509ThumbprintHex'

# parameters.json - sourceVaultValue
az keyvault show -n sf-1709 --query 'id'

# parameters.json - certificateUrlValue
# Leave off last version past the cert name in parameters.json. You'll use it below though
az keyvault certificate show -n sf-1709 --vault-name sf-1709 --query 'sid'

# Create a cluster
az sf cluster create -g sf-1709 -n sf-1709 -l southcentralus --template-file sf-1709/template.json --parameter-file sf-1709/parameters.json --secret-identifier https://sf-1709.vault.azure.net/secrets/sf-1709/feef2786774d421a9e61d89688be23cf
# Note: wait a while for it to the cluster to come up

# Download cert
az keyvault secret show -n sf-1709 --vault-name sf-1709 --query 'value' -o tsv | base64 -d -w 0 > certs/sf-1709.pfx

# Import cert (I'm using WSL magic for my box)
powershell.exe -Command Import-PfxCertificate -FilePath C:\\temp\\sfctl\\certs\\sf-1709.pfx -CertStoreLocation Cert:\CurrentUser\\My -Exportable
```

## [Create an Azure File share](https://docs.microsoft.com/en-us/azure/storage/files/storage-how-to-create-file-share)

## Set up SMB global mapping on your nodes

RDP to your nodes and run the following (remember, 1709 is Server Core!)

SMB global mappings don't appear to persist between restarts, so you'll want to automate this for sure

```powershell
powershell

$password = convertto-securestring "<storage_account_key>" -AsPlainText -Force
$cred = new-object System.Management.Automation.PSCredential -ArgumentList "Azure\<storage_account_name>", $password
New-SmbGlobalMapping -RemotePath "\\<storage_account_name>.file.core.windows.net\<share_name>" -Credential $cred -LocalPath Z:
```

### TODO: automated setup using a VM extension / etc/

## Deploy Minecraft

Deploy the `minecraft2016` project from Visual Studio 2017

### TODO: Use VS Code & sfctl instead of full VS

```bash
# Convert to pem. No password cause I'm lazy
openssl pkcs12 -in sf-1709.pfx -out sf-1709.pem -nodes

# connect to cluster
sfctl cluster select --endpoint https://sf-1709.westus2.cloudapp.azure.com:19080/Explorer --pem certs/sf-1709.pem --no-verify

# Compose doesn't work because 2016 containers need to be run in hyperv isolation mode
#sfctl compose create --deployment-name minecraft2016 --file-path docker-compose.yml
# deploy the minecraft2016 VS project instead
```

### TODO: Port noelbundick/minecraft-server:nanoserver to 1709
# Service Fabric and Server 1709 volumes demo

## Set up a cluster

```bash
# Create a cluster
az sf cluster create \
  -g sf-1709 \
  -l eastus \
  --template-file sf-1709/template.json \
  --parameter-file sf-1709/parameters.json \
  --vault-name sf-1709 \
  --certificate-subject-name sf-1709 \
  --certificate-password 'Password#1234' \
  --certificate-output-folder .

# Import cert (I'm using WSL magic for my box)
powershell.exe Import-PfxCertificate -FilePath 'C:\code\noelbundick\service-fabric-1709-demo\sf-1709201802051346.pfx' -CertStoreLocation 'Cert:\CurrentUser\My\'
```

## [Create an Azure File share](https://docs.microsoft.com/en-us/azure/storage/files/storage-how-to-create-file-share)

```shell
az storage account create -n sf1709data -g sf-1709 --sku Standard_LRS
az storage share create -n minecraft --account-name sf1709data
```

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

### Option 1 - Deploy Minecraft via Compose

```bash
# Convert to pem. No password cause I'm lazy
openssl pkcs12 -in sf-1709.pfx -out sf-1709.pem -nodes

# Select the cluster
sfctl cluster select --endpoint https://sf-1709.westus2.cloudapp.azure.com:19080/Explorer --pem certs/sf-1709.pem --no-verify

# Deploy minecraft to the cluster via 
sfctl compose create --deployment-name minecraft --file-path docker-compose.yml
```

## Option 2 - Deploy Minecraft via Visual Studio 2017

Deploy the `minecraft` project from Visual Studio 2017

## TODO: Port noelbundick/minecraft-server:nanoserver to 1709

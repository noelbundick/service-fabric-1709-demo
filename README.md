# Service Fabric + Windows Server 1709 volumes demo

## Overview

// TODO

## Walkthrough

### Requirements

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
* [Service Fabric SDK & Tools](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-get-started)

### Set up a cluster

Run the following commands in PowerShell, replacing the cert path with your own

```powershell
# Create a cluster
az sf cluster create `
  -g sf-1709 `
  -l eastus `
  --template-file sf-1709/template.json `
  --parameter-file sf-1709/parameters.json `
  --vault-name sf-1709 `
  --certificate-subject-name sf-1709 `
  --certificate-password 'Password#1234' `
  --certificate-output-folder .

# Import cert
Import-PfxCertificate -FilePath '.\sf-1709201802051346.pfx' -CertStoreLocation 'Cert:\CurrentUser\My\'
```

### [Create an Azure File share](https://docs.microsoft.com/en-us/azure/storage/files/storage-how-to-create-file-share)

```powershell
az storage account create -n sf1709data -g sf-1709 --sku Standard_LRS
az storage share create -n minecraft --account-name sf1709data
```

### Deploy Minecraft via Visual Studio 2017

Deploy the `minecraft` project from Visual Studio 2017

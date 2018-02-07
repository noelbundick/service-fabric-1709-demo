$ErrorActionPreference = "Stop"

# Get arguments from environment vars
$account_name = $env:container_storageAccountName
$account_key = $env:container_storageAccountKey
$share_name = $env:container_storageAccountShare
$data_folder = $env:container_dataFolder

# All Azure file shares will be mapped from "\\{storageAcct}.file.core.windows.net\{shareName}" to "D:\smbmappings\{storageAcct}-{shareName}"
$mapping_remote_target = "\\$account_name.file.core.windows.net\$share_name"
$mapping_local_root = "D:\smbmappings"
$mapping_local_folder = "${account_name}-${share_name}"

# Ensure root folder exists
mkdir $mapping_local_root -Force

# Only create the SMB global mapping if it doesn't already exist
$mapping = Get-SmbGlobalMapping -RemotePath $mapping_remote_target -ErrorAction SilentlyContinue
if (!$mapping) {
	$password = ConvertTo-SecureString $account_key -AsPlainText -Force
	$cred = New-Object System.Management.Automation.PSCredential -ArgumentList "Azure\$account_name", $password
	New-SmbGlobalMapping -RemotePath $mapping_remote_target -Credential $cred
}

# Creating a directory symlink from PowerShell doesn't work with absolute paths, so we'll hop into the root folder
pushd $mapping_local_root

# Link remote file share to local folder under D:\smbmappings
New-Item -ItemType SymbolicLink -Name $mapping_local_folder -Target $mapping_remote_target -Force

# Create data folder inside file share
mkdir "$data_folder" -Force

popd
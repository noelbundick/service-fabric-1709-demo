$account_name = $env:minecraft_storageAccountName
$account_key = $env:minecraft_storageAccountKey
$share_name = $env:minecraft_storageAccountShare
$world_folder = $env:minecraft_worldFolder

$password = ConvertTo-SecureString $account_key -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential -ArgumentList "Azure\$account_name", $password
New-SmbGlobalMapping -RemotePath "\\$account_name.file.core.windows.net\$share_name" -Credential $cred -LocalPath Z:
mkdir "$world_folder" -Force
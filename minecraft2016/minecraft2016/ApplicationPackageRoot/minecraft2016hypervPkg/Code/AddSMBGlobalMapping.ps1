$account_name = 'sf1709cdata'
$account_key = 'DqtY62yKO6UpJv7G3ibj5tLcTaqnSYheHbcK+oEva93LNACtsCONBY4b+xdOVbVLlradkX0UlqIiruHblPN/5w=='
$share_name = 'minecraft'

$password = ConvertTo-SecureString $account_key -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential -ArgumentList "Azure\$account_name", $password
New-SmbGlobalMapping -RemotePath "\\$account_name.file.core.windows.net\$share_name" -Credential $cred -LocalPath Z:
mkdir Z:\minecraft -Force
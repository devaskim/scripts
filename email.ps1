ipconfig  | Out-Null 
# [Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("windows-1251")
# [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "Encoding: $([System.Text.Encoding]::Default.EncodingName)" 
Write-Host "Encoding: $([System.Text.Encoding]::Default.CodePage)"   

$subject="Theme"
$body="Body"

Write-Host "---------- BEFORE ENCODING ---------"
Write-Host $subject
Write-Host $body
Write-Host "---------- AFTER ENCODING ---------"

$password="egwyxnfiwpmnjuqf"
$email="denisdenisi4@yandex.ru"
$smtp="smtp.yandex.ru"
$port=587

$password = ConvertTo-SecureString $password -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential($email, $password)

Send-MailMessage `
-SmtpServer $smtp ` 
-Port $port ` 
-To $email `
-From $email `
-Subject $subject `
-Body $body `
-Encoding UTF8 `
-UseSsl `
-Credential $credentials

ipconfig  | Out-Null 
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "Encoding: $([System.Text.Encoding]::Default.EncodingName)" 
Write-Host "Encoding: $([System.Text.Encoding]::Default.CodePage)"  

# $subject=$(Get-Content -Path text.txt -Encoding UTF8)

$subject="Привет"
$body="Body"

$subject | Set-Content -Encoding UTF8 temp.txt
$subject=$(Get-Content -Path temp.txt -Encoding UTF8)

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

Send-MailMessage -SmtpServer $smtp -Port $port -To $email -From $email -Subject $subject -Body $body -Encoding UTF8 -UseSsl -Credential $credentials

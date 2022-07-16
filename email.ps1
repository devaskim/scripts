ipconfig  | Out-Null 
[Console]::OutputEncoding = [System.Text.Encoding]::Default

Write-Host "Encoding: $([System.Text.Encoding]::Default.EncodingName)" 
Write-Host "Encoding: $([System.Text.Encoding]::Default.CodePage)"  

$subject="а"
$body="Body"

Write-Host ($subject.Length)
Write-Host ([System.Text.Encoding]::Default.GetByteCount($subject))
Write-Host ([System.Text.Encoding]::Default.GetBytes($subject))

Write-Host "---------- TEXT START ---------"
Write-Host $subject
Write-Host $body
Write-Host "---------- TEXT END ---------"

$bytes=[System.Text.Encoding]::Default.GetBytes($subject)
$subject2=[System.Text.Encoding]::UTF8.GetString($bytes)


$password="egwyxnfiwpmnjuqf"
$email="denisdenisi4@yandex.ru"
$smtp="smtp.yandex.ru"
$port=587

$password = ConvertTo-SecureString $password -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential($email, $password)

Send-MailMessage -SmtpServer $smtp -Port $port -To $email -From $email -Subject $subject -Body $body -Encoding ([System.Text.Encoding]::Default) -UseSsl -Credential $credentials

Send-MailMessage -SmtpServer $smtp -Port $port -To $email -From $email -Subject $subject2 -Body $body -Encoding UTF8 -UseSsl -Credential $credentials

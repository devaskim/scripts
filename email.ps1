ipconfig  | Out-Null 
[Console]::OutputEncoding = [System.Text.Encoding]::Default

Write-Host "Encoding: $([System.Text.Encoding]::Default.EncodingName)" 
Write-Host "Encoding: $([System.Text.Encoding]::Default.CodePage)"

function convertToUtf8($str) {
    return [System.Text.Encoding]::UTF8.GetString([System.Text.Encoding]::Default.GetBytes($subject))
}

$subject=$(convertToUtf8 "Привет")
$body="Body"

Write-Host "---------- TEXT START ---------"
Write-Host $subject
Write-Host $body
Write-Host "---------- TEXT END ---------"

$password="egwyxnfiwpmnjuqf"
$email="denisdenisi4@yandex.ru"
$smtp="smtp.yandex.ru"
$port=587

$password = ConvertTo-SecureString $password -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential($email, $password)

Send-MailMessage -SmtpServer $smtp -Port $port -To $email -From $email -Subject $subject2 -Body $body -Encoding UTF8 -UseSsl -Credential $credentials

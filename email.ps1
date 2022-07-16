ipconfig  | Out-Null 
[Console]::OutputEncoding = [System.Text.Encoding]::Default

function convertToUtf8($str) {
    return [System.Text.Encoding]::UTF8.GetString([System.Text.Encoding]::Default.GetBytes($str))
}

$subject="Письмо из Повершелла"
$body="Тимсити и Повершелл побеждены!!!"

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

Send-MailMessage -SmtpServer $smtp -Port $port -UseSsl -Credential $credentials -To $email -From $email -Subject $(convertToUtf8 $subject) -Body $(convertToUtf8 $body) -Encoding UTF8


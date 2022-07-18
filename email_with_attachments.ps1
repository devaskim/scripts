[Console]::OutputEncoding = [System.Text.Encoding]::Default

function convertToUtf8($str) {
    return [System.Text.Encoding]::UTF8.GetString([System.Text.Encoding]::Default.GetBytes($str))
}

$subject="C вложением"
$body="Тимсити и Повершелл побеждены!!!"

Write-Host "---------- TEXT START ---------"
Write-Host "Тема: $subject"
Write-Host "Письмо: $body"
Write-Host "---------- TEXT END ---------"

$email="denisdenisi4@yandex.ru"
$smtp="smtp.yandex.ru"
$port=587

$password = ConvertTo-SecureString "egwyxnfiwpmnjuqf" -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential($email, $password)

$FILES=If ($env:FILES) {$env:FILES} Else {""}
Send-MailMessage -Attachments $FILES -SmtpServer $smtp -Port $port -UseSsl -Credential $credentials -To $email -From $email -Subject $(convertToUtf8 $subject) -Body $(convertToUtf8 $body) -Encoding UTF8

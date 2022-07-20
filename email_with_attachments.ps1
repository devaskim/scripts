[Console]::OutputEncoding = [System.Text.Encoding]::Default

$from="denisdenisi4@yandex.ru"
$smtp="smtp.yandex.ru"
$to=$(if ($env:TO) { $($env:TO -split '\s+') } else { @( $from ) })

$subject="Письмо с вложением"
$body="Тимсити и Повершелл побеждены!!!"

$JIRADSO_USER="dyosick89@gmail.com"
$JIRADSO_PASSWORD="Wtr0mYPBG6hMMLmCn690C32C"
$JIRADSO_URL="https://batparse.atlassian.net"
$JIRA_REST_ISSUE="$JIRADSO_URL/rest/api/latest/issue"
$JIRA_TASK_SOURCE="BAT-1"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$encodedCredentials = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$($JIRADSO_USER):$($JIRADSO_PASSWORD)")) 
$authHeader = @{
    "Authorization" = "Basic $encodedCredentials"
}

$response = Invoke-WebRequest -Headers $authHeader `
                              -Method Get `
                              -Uri "$JIRA_REST_ISSUE/$JIRA_TASK_SOURCE"
$sourceTaskJson = ConvertFrom-Json $response.content

$subject=$sourceTaskJson.fields.summary

Write-Host "---------- MAIL START ---------"
Write-Host "Кому: $($to -join ',')"
Write-Host "Тема письма: $subject"
Write-Host "Тело письма: $body"
Write-Host  $(if ($env:FILES) { "Вложения: $env:FILES" } else { "--нет вложений---" })
Write-Host "---------- MAIL END ---------"

function convertToUtf8($str) {
    return [System.Text.Encoding]::UTF8.GetString([System.Text.Encoding]::Default.GetBytes($str))
}

$CURRENT_DIR=Get-Location

$mail = new-object System.Net.Mail.MailMessage
$mail.From = $from
$mail.Subject = $(convertToUtf8 $subject)  
$mail.Body = $(convertToUtf8 $body)

if ($env:FILES) {
    $env:FILES -split '\s+' | ForEach-Object {	
        $FILE=$_

        if (!(Test-Path $FILE)) {
            Write-Host "Файл '$($FILE)' не найден"
            continue
        }

        $attachment = new-object System.Net.Mail.Attachment("$CURRENT_DIR\$FILE")
        $mail.Attachments.Add($attachment)
    }
}

foreach ($address in $to) {
    $mail.To.Add($address);
}

$client = new-object system.net.mail.smtpclient($smtp)
if ($smtp.IndexOf("vtb") -eq -1) {
    $client.Port = 587
    $client.EnableSsl = $true 
    $client.Credentials = New-Object System.Net.NetworkCredential($from, "egwyxnfiwpmnjuqf");
}
 
try {  
   $client.Send($mail)  
   Write-Host "Письмо отправлено"
} catch {  
    "Ошибка при отправке письма: {0}" -f $Error.ToString()  
	Write-Host $_
}
break

# [Console]::OutputEncoding = [System.Text.Encoding]::Default

$email="denisdenisi4@yandex.ru"
$smtp="smtp.yandex.ru"

$subject="Письмо с вложением"
$body="Тимсити и Повершелл побеждены!!!"

Write-Host "---------- MAIL START ---------"
Write-Host "Тема письма: $subject"
Write-Host "Тело письма: $body"
Write-Host  $(if ($env:FILES) { "Вложения: $env:FILES" } else { "--нет вложений---" })
Write-Host "---------- MAIL END ---------"

function convertToUtf8($str) {
    return [System.Text.Encoding]::UTF8.GetString([System.Text.Encoding]::Default.GetBytes($str))
}

$CURRENT_DIR=Get-Location

$message = new-object System.Net.Mail.MailMessage($email, $email)
$message.Subject = $(convertToUtf8 $subject)  
$message.Body = $(convertToUtf8 $body)

if ($env:FILES) {
	$env:FILES -split '\s+' | ForEach-Object {	
		$FILE=$_

		if (!(Test-Path $FILE)) {
			Write-Host "Файл '$($FILE)' не найден"
			continue
		}

		$attachment = new-object System.Net.Mail.Attachment("$CURRENT_DIR\$FILE")
		$message.Attachments.Add($attachment)
	}
}

$client = new-object system.net.mail.smtpclient($smtp, $(if ($smtp.IndexOf("vtb") -ne -1) { 25 } else { 587 }))
if ($client.Port -ne 25) {
    $client.EnableSsl = $true 
    $client.Credentials = New-Object System.Net.NetworkCredential($email, "egwyxnfiwpmnjuqf);
}
 
"Отправляем письмо адресату {0} через {1} порт {2}." -f $client.To, $client.Host, $client.Port  
try {  
   $client.Send($message)  
   "Письмо от: {1}, кому: {0} успешно отправлено" -f $client.From, $client.To
} catch {  
  "Ошибка при отправке письма: {0}" -f $Error.ToString()  
} 
break

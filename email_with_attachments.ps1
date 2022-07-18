[Console]::OutputEncoding = [System.Text.Encoding]::Default

function convertToUtf8($str) {
    return [System.Text.Encoding]::UTF8.GetString([System.Text.Encoding]::Default.GetBytes($str))
}

$subject="C вложением"
$body="Тимсити и Повершелл побеждены!!!"

Write-Host "---------- MAIL START ---------"
Write-Host "Тема письма: $subject"
Write-Host "Тело письма: $body"
if ($env:FILES) {
	Write-Host "Вложения: $env:FILES"
} else {
	Write-Host "--нет вложений---"
}
Write-Host "---------- MAIL END ---------"

$CURRENT_DIR=Get-Location
 
$from = New-Object System.Net.Mail.MailAddress $email
$to = New-Object System.Net.Mail.MailAddress $email

$message = new-object System.Net.Mail.MailMessage $from, $to  
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

$server = $smtp
$client = new-object system.net.mail.smtpclient $server  
 
"Отправляем письмо адресату {0} через {1} порт {2}." -f $to.ToString(), $client.Host, $client.Port  
try {  
   $client.Send($message)  
   "Письмо от: {1}, кому: {0} успешно отправлено" -f $from, $to  
} catch {  
  "Ошибка при отправке письма: {0}" -f $Error.ToString()  
} 
break

Write-Host ([System.Text.Encoding]::Default.EncodingName)
break

ipconfig  | Out-Null 
[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("windows-1251")

function ConvertTo-Encoding ([string]$From, [string]$To){
	Begin{
		$encFrom = [System.Text.Encoding]::GetEncoding($from)
		$encTo = [System.Text.Encoding]::GetEncoding($to)
	}
	Process{
		$bytes = $encTo.GetBytes($_)
		$bytes = [System.Text.Encoding]::Convert($encFrom, $encTo, $bytes)
		$encTo.GetString($bytes)
	}
}

$smtp="smtp.dev.vtb.ru"
$email="romanovskii@dev.vtb.ru"
$subject="Тема письма на русском"
$body="Тестовое письмо"

Write-Host "---------- BEFORE ENCODING ---------"
Write-Host $subject
Write-Host $body

$subject= $subject | ConvertTo-Encoding "windows-1251" "utf-8"
$body= $body | ConvertTo-Encoding "windows-1251" "utf-8"

Write-Host "---------- AFTER ENCODING ---------"
Write-Host $subject
Write-Host $body

$encoding = [System.Text.Encoding]::UTF8
# Send-MailMessage -SmtpServer $smtp -To $email -From $email -Subject $subject -Body $body -Encoding $encoding

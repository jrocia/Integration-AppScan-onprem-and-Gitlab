$sessionId=$(Invoke-WebRequest -Method "POST" -Headers @{"Accept"="application/json"} -ContentType 'application/json' -Body "{`"keyId`": `"$aseApiKeyId`",`"keySecret`": `"$aseApiKeySecret`"}" -Uri "https://$aseHostname`:9443/ase/api/keylogin/apikeylogin" -SkipCertificateCheck | Select-Object -Expand Content | ConvertFrom-Json | select -ExpandProperty sessionId);
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession;
$session.Cookies.Add((New-Object System.Net.Cookie("asc_session_id", "$sessionId", "/", "$aseHostname")));
$aseAppId=$(Invoke-WebRequest -WebSession $session -Headers @{"Asc_xsrf_token"="$sessionId"} -Uri "https://$aseHostname`:9443/ase/api/applications/search?searchTerm=$aseAppName" -SkipCertificateCheck | ConvertFrom-Json).id;
if ([string]::IsNullOrWhitespace($aseAppId)){
	$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession;
	$session.Cookies.Add((New-Object System.Net.Cookie("asc_session_id", "$sessionId", "/", "$aseHostname")));
	$aseAppId=$(Invoke-WebRequest -Method POST -WebSession $session -Headers @{"Asc_xsrf_token"="$sessionId"} -ContentType "application/json" -Body "{`"name`":`"$aseAppName`" }" -Uri "https://$aseHostname`:9443/ase/api/applications" -SkipCertificateCheck | ConvertFrom-Json).id;
	echo "$aseAppId" > aseAppId.txt
	write-host "======== Step: Creating application in AppScan Enterprise ========"
	write-host "Application $aseAppName registered with id $aseAppId"
    }
else{
	write-host "======== Step: Checking application in AppScan Enterprise ========"
	write-host "There is a registered application."
	}

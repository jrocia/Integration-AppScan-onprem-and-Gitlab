write-host "======== Step: Checking folder name in AppScan Enterprise ========"
# ASE authentication
$sessionId=$(Invoke-WebRequest -Method "POST" -Headers @{"Accept"="application/json"} -ContentType 'application/json' -Body "{`"keyId`": `"$aseApiKeyId`",`"keySecret`": `"$aseApiKeySecret`"}" -Uri "https://$aseHostname`:9443/ase/api/keylogin/apikeylogin" -SkipCertificateCheck | Select-Object -Expand Content | ConvertFrom-Json | select -ExpandProperty sessionId);
# Looking for $aseAppName into ASE
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession;
$session.Cookies.Add((New-Object System.Net.Cookie("asc_session_id", "$sessionId", "/", "$aseHostname")));
#  Looking for $aseAppFolderId into ASE
$aseAppFolderId=$(Invoke-WebRequest -WebSession $session -Headers @{"Asc_xsrf_token"="$sessionId"} -Uri "https://$aseHostname`:9443/ase/api/folders/search?searchString=$aseAppName" -SkipCertificateCheck | ConvertFrom-Json).folderId;
# If $aseAppFolderId is Null create the application folder into ASE else just get the aseAppFolderId
if ([string]::IsNullOrWhitespace($aseAppFolderId)){
	$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession;
	$session.Cookies.Add((New-Object System.Net.Cookie("asc_session_id", "$sessionId", "/", "$aseHostname")));
	[XML]$aseAppFolder=$(Invoke-WebRequest -Method POST -WebSession $session -Headers @{"Asc_xsrf_token"="$sessionId"} -ContentType "application/json" -Body "{`"parentId`":1,`"folderName`":`"$aseAppName`",`"description`":`"`",`"contact`":0}" -Uri "https://$aseHostname`:9443/ase/api/folders/create" -SkipCertificateCheck);
	write-output $aseAppFolder.folder.id > aseAppFolderId.txt;
	write-host "aseAppFolderId $aseAppFolderId created for Application $aseAppName.";
    }
else{
	write-host "There is a aseAppFolderId $aseAppFolderId created."
	}

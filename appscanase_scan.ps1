write-host "======== Step: Running scan in $url ========"
$sessionId=$(Invoke-WebRequest -Method "POST" -Headers @{"Accept"="application/json"} -ContentType 'application/json' -Body "{`"keyId`": `"$aseApiKeyId`",`"keySecret`": `"$aseApiKeySecret`"}" -Uri "https://$aseHostname`:9443/ase/api/keylogin/apikeylogin" -SkipCertificateCheck | Select-Object -Expand Content | ConvertFrom-Json | select -ExpandProperty sessionId);

$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession;
$session.Cookies.Add((New-Object System.Net.Cookie("asc_session_id", "$sessionId", "/", "$aseHostname")));
$aseAppId=$(Invoke-WebRequest -WebSession $session -Headers @{"Asc_xsrf_token"="$sessionId"} -Uri "https://$aseHostname`:9443/ase/api/applications/search?searchTerm=$aseAppName" -SkipCertificateCheck | ConvertFrom-Json).id;
write-host $sessionId

$scanName="$CI_PROJECT_NAME-$CI_JOB_ID";
write-host $scanName;

$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession;
$session.Cookies.Add((New-Object System.Net.Cookie("asc_session_id", "$sessionId", "/", "$aseHostname")));
$jobId=$(Invoke-WebRequest -Method "POST" -WebSession $session -Headers @{"asc_xsrf_token"="$sessionId" ; "Accept"="application/json"} -ContentType "application/json" -Body "{`"testPolicyId`":`"3`",`"folderId`":`"1`",`"applicationId`":`"$aseAppId`",`"name`":`"$scanName`",`"description`":`"`",`"contact`":`"`"}" -Uri "https://$aseHostname`:9443/ase/api/jobs/$scanTemplate/dastconfig/createjob" -SkipCertificateCheck | Select-Object -Expand Content | ConvertFrom-Json | select -ExpandProperty Id);
write-output "$jobId" > jobId_var.txt;
write-output $scanName > scanName_var.txt;
write-host "Scan name will be $scanName. You can filter all issues found through Scan Name:$scanName ($jobId)";
write-host "The JobId was created, its name is $jobId and its located in ASE folder";
 
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession;
$session.Cookies.Add((New-Object System.Net.Cookie("asc_session_id", "$sessionId", "/", "$aseHostname")));
Invoke-WebRequest -Method "POST" -WebSession $session -Headers @{"asc_xsrf_token"="$sessionId" ; "Accept"="application/json"} -ContentType "application/json" -Body "{`"scantNodeXpath`":`"StartingUrl`",`"scantNodeNewValue`":`"$url`"}" -Uri "https://$aseHostname`:9443/ase/api/jobs/$jobId/dastconfig/updatescant" -SkipCertificateCheck | Out-Null;
write-host "The URL Target was updated in Job Id. It was updated to $url";

if ([System.IO.File]::Exists($loginDastConfig)){
  write-host "$loginDastConfig exists. So it will be uploaded to the Job and will be used to Authenticate in the URL target during tests.";
  curl -s --header 'X-Requested-With: XMLHttpRequest' --header "Cookie: asc_session_id=$sessionId;" --header "Asc_xsrf_token: $sessionId" -F "uploadedfile=@$loginDastConfig" "https://$aseHostname`:9443/ase/api/jobs/$jobId/dastconfig/updatetraffic/login" --insecure;
  }
else{
  write-host "Login file not identified."
  }

if ([System.IO.File]::Exists($manualExploreDastConfig)){
  write-host "$manualExploreDastConfig exists. So it will be uploaded to the Job and will be used during security tests (test only scan mode).";
  curl -s --header 'X-Requested-With: XMLHttpRequest' --header "Cookie: asc_session_id=$sessionId;" --header "Asc_xsrf_token: $sessionId" -F "uploadedfile=@$manualExploreDastConfig" "https://$aseHostname`:9443/ase/api/jobs/$jobId/dastconfig/updatetraffic/add" --insecure;
  curl -s -X PUT --header 'X-Requested-With: XMLHttpRequest' --header "Cookie: asc_session_id=$sessionId;" --header "Asc_xsrf_token: $sessionId" -F "uploadedfile=@$manualExploreDastConfig" "https://$aseHostname`:9443/ase/api/jobs/scantype?scanTypeId=3&jobId=$jobId" --insecure;
  }      
else{
  write-host "Manual explorer file not identified."
  }

$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession;
$session.Cookies.Add((New-Object System.Net.Cookie("asc_session_id", "$sessionId", "/", "$aseHostname")));
$eTag=$(Invoke-WebRequest -WebSession $session -Headers @{"Asc_xsrf_token"="$sessionId"} -Uri "https://$aseHostname`:9443/ase/api/jobs/$jobId" -SkipCertificateCheck).headers.Etag;
write-host "The Etag is $eTag. It is used to verify that is jobs state has not been changed or updated before making the changes to the job.";

$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession;
$session.Cookies.Add((New-Object System.Net.Cookie("asc_session_id", "$sessionId", "/", "$aseHostname")));
Invoke-WebRequest -Method "POST" -WebSession $session -Headers @{"asc_xsrf_token"="$sessionId" ; "Accept"="application/json" ; "If-Match"="$eTag"} -ContentType "application/json" -Body "{`"type`":`"run`"}" -Uri "https://$aseHostname`:9443/ase/api/jobs/$jobId/actions?isIncremental=false&isRetest=false&basejobId=-1" -SkipCertificateCheck | Out-Null;
sleep 60;
    
$scanStatus="Running";
while ($scanStatus -ne "Ready"){
  $scanStatus=$((Invoke-WebRequest -WebSession $session -Headers @{"Asc_xsrf_token"="$sessionId"} -Uri "https://$aseHostname`:9443/ase/api/folderitems/$jobId/statistics" -SkipCertificateCheck).content | Convertfrom-json).statistics.status;
  write-host $scanStatus;
  sleep 60
  }
write-host "Scan finished. Requesting report generation."
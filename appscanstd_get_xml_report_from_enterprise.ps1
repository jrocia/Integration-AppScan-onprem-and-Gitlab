write-host "======== Step: Requesting and Exporting XML from ASE ========"
# Input variable: $scanName, $aseHostname, $aseApiKeyId, $aseApiKeySecret

$outputContent=Get-Content .\scanName_var.txt
$scanName=$outputContent.Replace("`0","") | Select-String -Pattern "AppScan Enterprise job '(.*)'" | % {$_.Matches.Groups[1].Value}

$sessionId=$(Invoke-WebRequest -Method "POST" -Headers @{"Accept"="application/json"} -ContentType 'application/json' -Body "{`"keyId`": `"$aseApiKeyId`",`"keySecret`": `"$aseApiKeySecret`"}" -Uri "https://$aseHostname`:9443/ase/api/keylogin/apikeylogin" -SkipCertificateCheck | Select-Object -Expand Content | ConvertFrom-Json | select -ExpandProperty sessionId);

$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession;
$session.Cookies.Add((New-Object System.Net.Cookie("asc_session_id", "$sessionId", "/", "$aseHostname")));
$aseAppId=$(Invoke-WebRequest -WebSession $session -Headers @{"Asc_xsrf_token"="$sessionId"} -Uri "https://$aseHostname`:9443/ase/api/applications/search?searchTerm=$aseAppName" -SkipCertificateCheck | ConvertFrom-Json).id;

$reportId=$(Invoke-WebRequest -Method "POST" -WebSession $session -Headers @{"asc_xsrf_token"="$sessionId" ; "Accept"="application/json"} -ContentType "application/json" -Body "{`"config`":{`"executiveSummaryIncluded`":false,`"advisoriesIncluded`":false,`"issueConfig`":{`"issueAttributeConfig`":{`"showEmptyValues`":true,`"attributeLookups`":[`"applicationname`",`"cvss`",`"comments`",`"description`",`"id`",`"location`",`"overdue`",`"scanname`",`"scanner`",`"severityvalue`",`"status`",`"datecreated`",`"fixeddate`",`"lastupdated`",`"accesscomplexity`",`"accessvector`",`"authentication`",`"availabilityimpact`",`"confidentialityimpact`",`"exploitability`",`"integrityimpact`",`"remediationlevel`",`"reportconfidence`",`"api`",`"callingline`",`"callingmethod`",`"class`",`"classification`",`"databasename`",`"databaseservicename`",`"databasetype`",`"databaseversion`",`"discoverymethod`",`"domain`",`"element`",`"externalid`",`"host`",`"line`",`"package`",`"path`",`"port`",`"projectid`",`"projectname`",`"projectversion`",`"projectversionid`",`"scheme`",`"sourcefile`",`"third-partyid`",`"username`"]},`"includeAdditionalInfo`":false},`"pdfPageBreakOnIssue`":false,`"sortByURL`":false},`"layout`":{`"reportOptionLayoutCoverPage`":{`"companyLogo`":`"`",`"additionalLogo`":`"`",`"includeDate`":true,`"includeReportType`":false,`"reportTitle`":`"`",`"description`":`"`"},`"reportOptionLayoutBody`":{`"header`":`"`",`"footer`":`"`"},`"includeTableOfContents`":false},`"reportFileType`":`"XML`",`"issueIdsAndQueries`":[`"scanname=$scanName,status=New,status=Fixed,status=Reopened,status=InProgress,status=Open,status=Passed`"]}" -Uri "https://$aseHostname`:9443/ase/api/issues/reports/securitydetails?appId=$aseAppId" -SkipCertificateCheck | Select-Object -Expand Content | Select-String -Pattern "Report id: (Report\d+)" | % {$_.Matches.Groups[1].Value});
#$sessionId=$(Invoke-WebRequest -Method "POST" -Headers @{"Accept"="application/json"} -ContentType 'application/json' -Body "{`"keyId`": `"$aseApiKeyId`",`"keySecret`": `"$aseApiKeySecret`"}" -Uri "https://$aseHostname`:9443/ase/api/keylogin/apikeylogin" -SkipCertificateCheck | Select-Object -Expand Content | ConvertFrom-Json | select -ExpandProperty sessionId);

sleep 120;

$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession;
$session.Cookies.Add((New-Object System.Net.Cookie("asc_session_id", "$sessionId", "/", "$aseHostname")));
Invoke-WebRequest -WebSession $session -Headers @{"Asc_xsrf_token"="$sessionId"} -Uri "https://$aseHostname`:9443/ase/api/issues/reports/$reportId" -SkipCertificateCheck -OutFile scan_report.zip -PassThru;

write-host "The scan name $scanName was exported from Appscan Enterprise."

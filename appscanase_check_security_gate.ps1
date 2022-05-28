write-host "======== Step: Checking Security Gate ========"

$scanName=(Get-Content .\scanName_var.txt);
$jobId=(Get-Content .\jobId_var.txt);

$sessionId=$(Invoke-WebRequest -Method "POST" -Headers @{"Accept"="application/json"} -ContentType 'application/json' -Body "{`"keyId`": `"$aseApiKeyId`",`"keySecret`": `"$aseApiKeySecret`"}" -Uri "https://$aseHostname`:9443/ase/api/keylogin/apikeylogin" -SkipCertificateCheck | Select-Object -Expand Content | ConvertFrom-Json | select -ExpandProperty sessionId);

$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession;
$session.Cookies.Add((New-Object System.Net.Cookie("asc_session_id", "$sessionId", "/", "$aseHostname")));
$vulnSummary=$((Invoke-WebRequest -WebSession $session -Headers @{"Asc_xsrf_token"="$sessionId"}-Uri "https://$aseHostname`:9443/ase/api/summaries/issues_v2?query=scanname%3D$scanName%20($jobId)&group=Severity" -SkipCertificateCheck).content | ConvertFrom-json)

[int]$highIssues = $vulnSummary.numMatch[0]
[int]$mediumIssues = $vulnSummary.numMatch[1]
[int]$lowIssues = $vulnSummary.numMatch[2]
[int]$infoIssues = $vulnSummary.numMatch[3]
[int]$totalIssues = $vulnSummary.numMatch[0]+$vulnSummary.numMatch[1]+$vulnSummary.numMatch[2]+$vulnSummary.numMatch[3]
$maxIssuesAllowed = $maxIssuesAllowed -as [int]

write-host "There is $highIssues high issues, $mediumIssues medium issues, $lowIssues low issues and $infoIssues informational issues."
write-host "The company policy permit less than $maxIssuesAllowed $sevSecGw severity."

if (( $highIssues -gt $maxIssuesAllowed ) -and ( "$sevSecGw" -eq "highIssues" )) {
  write-host "Security Gate build failed";
  exit 1
  }
elseif (( $mediumIssues -gt $maxIssuesAllowed ) -and ( "$sevSecGw" -eq "mediumIssues" )) {
  write-host "Security Gate build failed";
  exit 1
  }
elseif (( $lowIssues -gt $maxIssuesAllowed ) -and ( "$sevSecGw" -eq "lowIssues" )) {
  write-host "Security Gate build failed";
  exit 1
  }
elseif (( $totalIssues -gt $maxIssuesAllowed ) -and ( "$sevSecGw" -eq "totalIssues" )) {
  write-host "Security Gate build failed";
  exit 1
  }
else{  
write-host "Security Gate passed"
  }

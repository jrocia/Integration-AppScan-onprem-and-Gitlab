# Copyright 2023 HCL America
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

write-host "======== Step: Checking Security Gate ========"
# Get the scanname variable and jobid variable from file scanName_var.txt and jobId_var.txt created by script appscanase_scan.ps1
$scanName=(Get-Content .\scanName_var.txt);
$jobId=(Get-Content .\jobId_var.txt);
# ASE Authentication getting sessionId
$sessionId=$(Invoke-WebRequest -Method "POST" -Headers @{"Accept"="application/json"} -ContentType 'application/json' -Body "{`"keyId`": `"$aseApiKeyId`",`"keySecret`": `"$aseApiKeySecret`"}" -Uri "https://$aseHostname`:9443/ase/api/keylogin/apikeylogin" -SkipCertificateCheck | Select-Object -Expand Content | ConvertFrom-Json | select -ExpandProperty sessionId);
# Get vulnerabilities total from ASE API and parse into json variable
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession;
$session.Cookies.Add((New-Object System.Net.Cookie("asc_session_id", "$sessionId", "/", "$aseHostname")));
$vulnSummary=$((Invoke-WebRequest -WebSession $session -Headers @{"Asc_xsrf_token"="$sessionId"}-Uri "https://$aseHostname`:9443/ase/api/summaries/issues_v2?query=scanname%3D$scanName%20($jobId)&group=Severity" -SkipCertificateCheck).content | ConvertFrom-json)
# Security Gate steps
[int]$criticalIssues = ($vulnSummary | Where {$_.tagName -eq 'Critical'}).numMatch
[int]$highIssues = ($vulnSummary | Where {$_.tagName -eq 'High'}).numMatch
[int]$mediumIssues = ($vulnSummary | Where {$_.tagName -eq 'Medium'}).numMatch
[int]$lowIssues = ($vulnSummary | Where {$_.tagName -eq 'Low'}).numMatch
[int]$infoIssues = ($vulnSummary | Where {$_.tagName -eq 'Information'}).numMatch
[int]$totalIssues = $highIssues+$mediumIssues+$lowIssues+$infoIssues
$maxIssuesAllowed = $maxIssuesAllowed -as [int]

write-host "There is $criticalIssues critical issues, $highIssues high issues, $mediumIssues medium issues, $lowIssues low issues and $infoIssues informational issues."
write-host "The company policy permit less than $maxIssuesAllowed $sevSecGw severity."

if (( $criticalIssues -gt $maxIssuesAllowed ) -and ( "$sevSecGw" -eq "criticalIssues" )) {
  write-host "Security Gate build failed";
  exit 1
  }
elseif (( $highIssues -gt $maxIssuesAllowed ) -and ( "$sevSecGw" -eq "highIssues" )) {
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

# If you want to delete every files after execution
# Remove-Item -path $CI_PROJECT_DIR\* -recurse -exclude *.pdf,*.json,*.xml -force

write-host "======== Step 6 - Checking Security Gate ========"
[XML]$xml = Get-Content *-sevsec.xml
$highIssues = $xml.XmlReport.Summary.Hosts.Host.TotalHighSeverityIssues
$mediumIssues = $xml.XmlReport.Summary.Hosts.Host.TotalMediumSeverityIssues
$lowIssues = $xml.XmlReport.Summary.Hosts.Host.TotalLowSeverityIssues
$infoIssues = $xml.XmlReport.Summary.Hosts.Host.TotalInformationalIssues
$totalIssues = $xml.XmlReport.Summary.Hosts.Host.Total
write-host "There is $highIssues high issues, $mediumIssues medium issues, $lowIssues low issues and $infoIssues informational issues."
write-host "The company policy permit less than $maxIssuesAllowed $sevSecGw severity."
if (( "$highIssues" -gt "$maxIssuesAllowed" ) -and ( "$sevSecGw" -eq "highIssues" )) {
  write-host "Security Gate build failed"
  exit 1
  }
elseif (( "$mediumIssues" -gt "$maxIssuesAllowed" ) -and ( "$sevSecGw" -eq "mediumIssues" )) {
  write-host "Security Gate build failed"
  exit 1
  }
elseif (( "$lowIssues" -gt "$maxIssuesAllowed" ) -and ( "$sevSecGw" -eq "lowIssues" )) {
  write-host "Security Gate build failed"
  exit 1
  }
elseif (( "$totalIssues" -gt "$maxIssuesAllowed" ) -and ( "$sevSecGw" -eq "totalIssues" )) {
  write-host "Security Gate build failed"
  exit 1
  }
write-host "Security Gate passed"

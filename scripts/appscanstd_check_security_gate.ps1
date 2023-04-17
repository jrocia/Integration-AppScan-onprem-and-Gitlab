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
# Loading XML file into a variable and get amount of issues
[XML]$xml = Get-Content *-sevsec.xml
[int]$highIssues = $xml.XmlReport.Summary.Hosts.Host.TotalHighSeverityIssues
[int]$mediumIssues = $xml.XmlReport.Summary.Hosts.Host.TotalMediumSeverityIssues
[int]$lowIssues = $xml.XmlReport.Summary.Hosts.Host.TotalLowSeverityIssues
[int]$infoIssues = $xml.XmlReport.Summary.Hosts.Host.TotalInformationalIssues
[int]$totalIssues = $xml.XmlReport.Summary.Hosts.Host.Total
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
# If you want to delete every files after execution
# Remove-Item -path $CI_PROJECT_DIR\* -recurse -exclude *.pdf,*.json,*.xml

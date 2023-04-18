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

write-host "======== Step: Converting ASE DAST XML to Gitlab JSON ========"
# Unzip scan_report.zip and open the folder
Expand-Archive .\scan_report.zip
cd .\scan_report\
# Preparing to convert from ASE XML to Gitlab Json format
$header="{`"version`":`"15.0.4`",`"vulnerabilities`":[";
echo $header | Out-File -Append -NonewLine .\gl-dast-report.json;
# Load list of ase xml files
$files=$(Get-Item -Path *.xml);
# For each XML file extract vulnerabilities items and add into gl-dast-report.json (vulnerability item session)
ForEach ($file in $files){
  [XML]$xml = Get-Content $file;
    # If there is just 1 vulnerability item in the XML file
    if ($xml.'xml-report'.'issue-group'.item.count -eq 1){
      $ErrorActionPreference = 'SilentlyContinue';
      $nameMessageDescriptionCode=$xml.'xml-report'.'issue-group'.item.'issue-type'.ref;
      $nameMessageDescriptionValue=($xml.'xml-report'.'issue-type-group'.item | Where-Object {$_.id -eq $xml.'xml-report'.'issue-group'.item.'issue-type'.ref}).name.Replace('"','');
      $cwe=($xml.'xml-report'.'issue-type-group'.item | Where-Object {$_.id -eq $xml.'xml-report'.'issue-group'.item.'issue-type'.ref}).cwe
      
      #$urlLocation=$xml.'xml-report'.'issue-group'.item.'attributes-group'.attribute[5].value.Replace('\','\\');
      $urlLocation=($xml.'xml-report'.'issue-group'.item.'attributes-group'.attribute | Where-Object{$_.name -eq 'Location:'}).value.Replace('\','\\');
            
      #$paramElement=$xml.'xml-report'.'issue-group'.item.'attributes-group'.attribute[34].value.Replace('"','');
      $paramElement=($xml.'xml-report'.'issue-group'.item.'attributes-group'.attribute | Where-Object{$_.name -eq 'Element:'}).value.Replace('"','');
      
      #$path=$xml.'xml-report'.'issue-group'.item.'attributes-group'.attribute[39].value.Replace('\','\\');
      $path=($xml.'xml-report'.'issue-group'.item.'attributes-group'.attribute | Where-Object{$_.name -eq 'Path:'}).value.Replace('\','\\');
      
      $sevValue=$xml.'xml-report'.'issue-group'.item.severity.Replace('Information','Info').Replace('Use CVSS','Unknown');
      $issueReason=$xml.'xml-report'.'issue-group'.item.'variant-group'.item.reasoning.Replace('"','');
      $issueSolution=($xml.'xml-report'.'remediation-group'.item | Where-Object {$_.id -eq $xml.'xml-report'.'issue-group'.item.remediation.ref}).name.Replace('"','');
      
      #$cveValue="$(Get-Random)"+"appscanid"+"$($xml.'xml-report'.'issue-group'.item.'attributes-group'.attribute[4].value)";
      $cveValue="$(Get-Random)"+"appscanid"+"$(($xml.'xml-report'.'issue-group'.item.'attributes-group'.attribute | Where-Object{$_.name -eq 'Id:'}).value)";     
      
      #$appscanId=$xml.'xml-report'.'issue-group'.item.'attributes-group'.attribute[4].value;
      $appscanId=($xml.'xml-report'.'issue-group'.item.'attributes-group'.attribute | Where-Object{$_.name -eq 'Id:'}).value;
      
      $idIssues="{`"id`":`"$([guid]::NewGuid().Guid)`",`"category`":`"dast`",`"name`":`"$nameMessageDescriptionValue`",`"message`":`"$nameMessageDescriptionValue in $path`",`"description`":`"$issueReason`",`"cve`":`"$cveValue`",`"solution`":`"$issueSolution`",`"severity`":`"$sevValue`",`"confidence`": `"Unknown`",`"scanner`":{`"id`":`"appscan_standard`",`"name`":`"HCL AppScan Standard`"},`"location`":{`"param`":`"$paramElement`",`"method`":`"$paramElement->Appscan_Report_Id_$appscanId`",`"hostname`":`"$urlLocation`"},`"identifiers`":[{`"type`":`"$nameMessageDescriptionCode`",`"name`":`"ASE: $nameMessageDescriptionCode`",`"value`":`"appscan_standard`",`"url`":`"https://$aseHostname`:9443/ase/api/issuetypes/howtofix?issueTypeId=wf-security-check-$nameMessageDescriptionCode`"},{`"type`":`"cwe`",`"name`":`"CWE-$cwe`",`"value`":`"$cwe`",`"url`":`"https://cwe.mitre.org/data/definitions/$cwe.html`"}]}," | Out-File -Append -NonewLine .\gl-dast-report.json;
    }
    else{
      $countIssues=$xml.'xml-report'.'issue-group'.item.count-1
      [array]$totalIssues=@(0..$countIssues);
      ForEach ($i in $totalIssues) {
        $ErrorActionPreference = 'SilentlyContinue';
        $nameMessageDescriptionCode=$xml.'xml-report'.'issue-group'.item[$i].'issue-type'.ref;
        $nameMessageDescriptionValue=($xml.'xml-report'.'issue-type-group'.item | Where-Object {$_.id -eq $xml.'xml-report'.'issue-group'.item[$i].'issue-type'.ref}).name.Replace('"','');
        $cwe=($xml.'xml-report'.'issue-type-group'.item | Where-Object {$_.id -eq $xml.'xml-report'.'issue-group'.item[$i].'issue-type'.ref}).cwe
        #$urlLocation=$xml.'xml-report'.'issue-group'.item[$i].'attributes-group'.attribute[5].value.Replace('\','\\');
        $urlLocation=($xml.'xml-report'.'issue-group'.item[$i].'attributes-group'.attribute | Where-Object{$_.name -eq 'Location:'}).value.Replace('\','\\');
        #$paramElement=$xml.'xml-report'.'issue-group'.item[$i].'attributes-group'.attribute[34].value.Replace('"','');
        $paramElement=($xml.'xml-report'.'issue-group'.item[$i].'attributes-group'.attribute | Where-Object{$_.name -eq 'Element:'}).value.Replace('"','');
        #$path=$xml.'xml-report'.'issue-group'.item[$i].'attributes-group'.attribute[39].value.Replace('\','\\');
        $path=($xml.'xml-report'.'issue-group'.item[$i].'attributes-group'.attribute | Where-Object{$_.name -eq 'Path:'}).value.Replace('\','\\');
        $sevValue=$xml.'xml-report'.'issue-group'.item[$i].severity.Replace('Information','Info').Replace('Use CVSS','Unknown');
        $issueReason=$xml.'xml-report'.'issue-group'.item[$i].'variant-group'.item.reasoning.Replace('"','');
        $issueSolution=($xml.'xml-report'.'remediation-group'.item | Where-Object {$_.id -eq $xml.'xml-report'.'issue-group'.item[$i].remediation.ref}).name.Replace('"','');
        #$cveValue="$(Get-Random)"+"appscanid"+"$($xml.'xml-report'.'issue-group'.item[$i].'attributes-group'.attribute[4].value)";
        $cveValue="$(Get-Random)"+"appscanid"+"$(($xml.'xml-report'.'issue-group'.item[$i].'attributes-group'.attribute | Where-Object{$_.name -eq 'Id:'}).value)";
        #$appscanId=$xml.'xml-report'.'issue-group'.item[$i].'attributes-group'.attribute[4].value;
        $appscanId=($xml.'xml-report'.'issue-group'.item[$i].'attributes-group'.attribute | Where-Object{$_.name -eq 'Id:'}).value;
        $idIssues="{`"id`":`"$([guid]::NewGuid().Guid)`",`"category`":`"dast`",`"name`":`"$nameMessageDescriptionValue`",`"message`":`"$nameMessageDescriptionValue in $path`",`"description`":`"$issueReason`",`"cve`":`"$cveValue`",`"solution`":`"$issueSolution`",`"severity`":`"$sevValue`",`"confidence`": `"Unknown`",`"scanner`":{`"id`":`"appscan_standard`",`"name`":`"HCL AppScan Standard`"},`"location`":{`"param`":`"$paramElement`",`"method`":`"$paramElement->Appscan_Report_Id_$appscanId`",`"hostname`":`"$urlLocation`"},`"identifiers`":[{`"type`":`"$nameMessageDescriptionCode`",`"name`":`"ASE: $nameMessageDescriptionCode`",`"value`":`"appscan_standard`",`"url`":`"https://$aseHostname`:9443/ase/api/issuetypes/howtofix?issueTypeId=wf-security-check-$nameMessageDescriptionCode`"},{`"type`":`"cwe`",`"name`":`"CWE-$cwe`",`"value`":`"$cwe`",`"url`":`"https://cwe.mitre.org/data/definitions/$cwe.html`"}]}," | Out-File -Append -NonewLine .\gl-dast-report.json;
      }
    }
  }
# Remove the last comma
$dastReport = Get-Content .\gl-dast-report.json;
$dastReport = $dastReport.SubString(0,$dastReport.Length-1) | Out-File -NonewLine .\gl-dast-report.json;
# Finish the vulnerability item session and start the url scanned session
"],`"scan`":{`"scanned_resources`":[" | Out-File -Append -NonewLine .\gl-dast-report.json;
# For each ASE XML file, extract url scanned and add into gl-dast-report.json (scanned resources session)
ForEach ($file in $files){
  [XML]$xml = Get-Content $file;
  $resItems=$xml.'xml-report'.'entity-group'.item.'url-name'.count-1
  [array]$totalResItems=@(0..$resItems);
  if ($xml.'xml-report'.'entity-group'.item.'url-name'.count -eq 1){
    $resItem=$xml.'xml-report'.'entity-group'.item.'url-name'.Replace('\','\\');
    $idResItems="{`"method`":`"GET`",`"type`":`"url`",`"url`":`"$resItem`"}," | Out-File -Append -NonewLine .\gl-dast-report.json
  }      
  else{
    ForEach ($i in $totalResItems) {
      $resItem=$xml.'xml-report'.'entity-group'.item[$i].'url-name'.Replace('\','\\');
      $idResItems="{`"method`":`"GET`",`"type`":`"url`",`"url`":`"$resItem`"}," | Out-File -Append -NonewLine .\gl-dast-report.json;
    }
  }
}
# Remove the last comma
$dastReport = Get-Content .\gl-dast-report.json;
$dastReport = $dastReport.SubString(0,$dastReport.Length-1) | Out-File -NonewLine .\gl-dast-report.json;
# Extract date from ASE XML and add into gl-dast-report.json
$reportDateTime=$xml.'xml-report'.layout.'report-date-and-time'.Replace('/','-').Replace(' ','T');
# Finish gl-dast-report.json
$footer="],`"analyzer`":{`"id`":`"appscan_standard`",`"name`":`"appscan_standard`",`"vendor`":{`"name`":`"HCL`"},`"version`":`"10.2.0`"},`"scanner`":{`"id`":`"dast`",`"name`":`"HCL AppScan`",`"url`":`"https://help.hcltechsw.com/appscan/Standard/10.2.0/topics/home.html`",`"vendor`":{`"name`":`"HCL`"},`"version`":`"10.2.0`"},`"type`":`"dast`",`"start_time`":`"$reportDateTime`",`"end_time`":`"$reportDateTime`",`"status`":`"success`"}}" | Out-File -Append -NonewLine .\gl-dast-report.json;
if ($xml.'xml-report'.'issue-group'.item.count -eq 0){
  clear-content .\gl-dast-report.json;
}
write-host "AppScan Enterprise XML result converted to gl-dast-report.json."
# Back to root folder
cd..

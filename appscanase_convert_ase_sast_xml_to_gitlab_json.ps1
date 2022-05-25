
write-host "======== Step: Converting ASE SAST XML to Gitlab JSON ========"
Expand-Archive .\scan_report.zip
cd .\scan_report\
$header="{`"version`":`"14.0.4`",`"vulnerabilities`":[";
echo $header | Out-File -Append -NonewLine .\gl-sast-report.json;
$files=$(Get-Item -Path *.xml);
ForEach ($file in $files){
  [XML]$xml = Get-Content $file;
  $countIssues=$xml.'xml-report'.'issue-group'.item.count-1
  [array]$totalIssues=@(0..$countIssues);
  ForEach ($i in $totalIssues) {
    $ErrorActionPreference = 'SilentlyContinue';
    $nameMessageDescriptionCode=$xml.'xml-report'.'issue-group'.item[$i].'issue-type'.ref;
    $nameMessageDescriptionValue=($xml.'xml-report'.'issue-type-group'.item | Where-Object {$_.id -eq $xml.'xml-report'.'issue-group'.item[$i].'issue-type'.ref}).name.Replace('"','');

    $callingMethod=$xml.'xml-report'.'issue-group'.item[$i].'attributes-group'.attribute[25].value.Replace('\','\\')
    $sourceFile=$xml.'xml-report'.'issue-group'.item[$i].'attributes-group'.attribute[46].value.Replace('\','\\')
		$fileLineLocation=$xml.'xml-report'.'issue-group'.item[$i].'attributes-group'.attribute[5].value.Replace('\','\\')
		$sourceLine=$xml.'xml-report'.'issue-group'.item[$i].'attributes-group'.attribute[5].value | select-string -pattern "(\d+)" | % {$_.Matches.Groups[1].value}

    $sevValue=$xml.'xml-report'.'issue-group'.item[$i].severity.Replace('Information','Info').Replace('Use CVSS','Unknown');
    $cveValue="$(Get-Random)"+"appscanid"+"$($xml.'xml-report'.'issue-group'.item[$i].'attributes-group'.attribute[4].value)";
    $appscanId=$xml.'xml-report'.'issue-group'.item[$i].'attributes-group'.attribute[4].value;
    
    $idIssues="{`"id`":`"$([guid]::NewGuid().Guid)`",`"category`":`"sast`",`"name`":`"$nameMessageDescriptionValue in $fileLineLocation`",`"message`":`"$nameMessageDescriptionValue in $fileLineLocation`",`"description`":`"$nameMessageDescriptionValue`",`"cve`":`"$cveValue`",`"severity`":`"$sevValue`",`"confidence`": `"Unknown`",`"scanner`":{`"id`":`"appscan_source`",`"name`":`"HCL AppScan Source`"},`"location`":{`"file`":`"$sourceFile $appscanId`",`"start_line`":$sourceLine,`"class`":`"$callingMethod`",`"method`":`"Appscan_Report_Id_$appscanId`"},`"identifiers`":[{`"type`":`"$nameMessageDescriptionCode`",`"name`":`"ASE: $nameMessageDescriptionCode`",`"value`":`"appscan_source`",`"url`":`"https://$aseHostname`:9443/ase/api/issuetypes/howtofix?issueTypeId=wf-security-check-$nameMessageDescriptionCode`"},{`"type`":`"cwe`",`"name`":`"CWE-699`",`"value`":`"699`",`"url`":`"https://cwe.mitre.org/data/definitions/699.html`"}]}," | Out-File -Append -NonewLine .\gl-sast-report.json;
  }
}

$sastReport = Get-Content .\gl-sast-report.json
$sastReport = $sastReport.SubString(0,$sastReport.Length-1) | Out-File -NonewLine .\gl-sast-report.json
$reportDateTime=$xml.'xml-report'.layout.'report-date-and-time'.Replace('/','-').Replace(' ','T')
$footer="],`"scan`":{`"analyzer`":{`"id`":`"appscan_source`",`"name`":`"appscan_source`",`"vendor`":{`"name`":`"HCL`"},`"version`":`"10.0.7`"},`"scanner`":{`"id`":`"sast`",`"name`":`"Find Security Issues`",`"url`":`"https://help.hcltechsw.com/appscan/Source/10.0.7/topics/home.html`",`"vendor`":{`"name`":`"HCL`"},`"version`":`"10.0.7`"},`"type`":`"sast`",`"start_time`":`"$reportDateTime`",`"end_time`":`"$reportDateTime`",`"status`":`"success`"}}" | Out-File -Append -NonewLine .\gl-sast-report.json
write-host "AppScan Enterprise XML result converted to gl-sast-report.json."

cd..

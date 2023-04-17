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

# copia este script para crear carpetas en ASE y crear los escaneos dentro de las carpetas.
# https://github.com/jrocia/Integration-AppScan-onprem-and-Gitlab/blob/main/scripts/appscanase_create_folder_ase.ps1
# Tenemos que hacer alguns pasos para "instalar" este paso a mas en la integracion.
# 1 - Tiene que correr antes de appscanase_scan
# 2 - Tenemos que hacer dos (2) cambios en lo script appscanase_scan
# 2.1 - agregar: $aseAppFolderId=Get-Content .\aseAppFolderId.txt
# 2.2 - cambio: $jobId=$(Invoke-WebRequest -Method "POST" -WebSession $session -Headers @{"asc_xsrf_token"="$sessionId" ; "Accept"="application/json"} -ContentType "application/json" -Body "{`"testPolicyId`":`"3`",`"folderId`":`"$aseAppFolderId`",`"applicationId`":`"$aseAppId`",`"name`":`"$scanName`",`"description`":`"`",`"contact`":`"`"}" -Uri "https://$aseHostname`:9443/ase/api/jobs/$scanTemplate/dastconfig/createjob" -SkipCertificateCheck | Select-Object -Expand Content | ConvertFrom-Json | select -ExpandProperty Id);

write-host "======== Step: Checking folder name in AppScan Enterprise ========"
# ASE authentication
$sessionId=$(Invoke-WebRequest -Method "POST" -Headers @{"Accept"="application/json"} -ContentType 'application/json' -Body "{`"keyId`": `"$aseApiKeyId`",`"keySecret`": `"$aseApiKeySecret`"}" -Uri "https://$aseHostname`:9443/ase/api/keylogin/apikeylogin" -SkipCertificateCheck | Select-Object -Expand Content | ConvertFrom-Json | select -ExpandProperty sessionId);
# Looking for $aseAppName into ASE
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession;
$session.Cookies.Add((New-Object System.Net.Cookie("asc_session_id", "$sessionId", "/", "$aseHostname")));
$aseAppFolderId=$(Invoke-WebRequest -WebSession $session -Headers @{"Asc_xsrf_token"="$sessionId"} -Uri "https://$aseHostname`:9443/ase/api/folders/search?searchString=$aseAppName" -SkipCertificateCheck | ConvertFrom-Json).folderId;
# If $aseAppFolderId is Null create the application folder into ASE else just get the aseAppFolderId
if ([string]::IsNullOrWhitespace($aseAppFolderId)){
	$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession;
	$session.Cookies.Add((New-Object System.Net.Cookie("asc_session_id", "$sessionId", "/", "$aseHostname")));
	[XML]$aseAppFolder=$(Invoke-WebRequest -Method POST -WebSession $session -Headers @{"Asc_xsrf_token"="$sessionId";"Accept"="application/xml"} -ContentType "application/json" -Body "{`"parentId`":1,`"folderName`":`"$aseAppName`",`"description`":`"`",`"contact`":0}" -Uri "https://$aseHostname`:9443/ase/api/folders/create" -SkipCertificateCheck).content.Replace('ï»¿','');
	write-output $aseAppFolder.folder.id > aseAppFolderId.txt;
	$aseAppFolderId=Get-Content .\aseAppFolderId.txt
	write-host "aseAppFolderId $aseAppFolderId created for Application $aseAppName.";
    }
else{
	write-host "There is a aseAppFolderId $aseAppFolderId created.";
	}

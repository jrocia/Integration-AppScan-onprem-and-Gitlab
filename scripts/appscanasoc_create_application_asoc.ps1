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

#$asocApiKeyId='xxxxxxxxxxxxxxxxxxxxxxxx'
#$asocApiKeySecret='xxxxxxxxxxxxxxxxxxxxxxxx'
#$asocAppName='xxxxxxxxxxxxxxxxxxxxxxxx'
#$asocAssetGroupId='xxxxxxxxxxxxxxxxxxxxxxxx'

$asocApiToken=($(Invoke-WebRequest -Method "POST" -Headers @{"accept"="application/json"} -ContentType "application/json" -Body ("{`"KeyId`":`"$asocApiKeyId`", `"KeySecret`":`"$asocApiKeySecret`"}") -Uri "https://cloud.appscan.com/api/V2/Account/ApiKeyLogin").content | ConvertFrom-Json).token

$asocAppNames=((Invoke-WebRequest -Method 'GET' -Headers @{"accept"="application/json";"authorization"="Bearer $asocApiToken"} -ContentType "application/json" 'https://cloud.appscan.com/api/V2/Apps/GetAsPage?%24select=Name,Id').content | ConvertFrom-Json).items

if ($asocAppName -in $asocAppNames.Name){
	$asocAppNames=((Invoke-WebRequest -Method 'GET' -Headers @{"accept"="application/json";"authorization"="Bearer $asocApiToken"} -ContentType "application/json" 'https://cloud.appscan.com/api/V2/Apps/GetAsPage?%24select=Name,Id').content | ConvertFrom-Json).items
	$asocAppId=($asocAppNames | where-object {$_.Name -eq $asocAppName}).id
	Write-host "The application $asocAppName already exists in ASoC. The Id is $asocAppId."
	write-output "$asocAppId" > asocAppId_var.txt;
	}
else{
	$asocAppId=((Invoke-WebRequest -Method "POST" -Headers @{"accept"="application/json";"authorization"="Bearer $asocApiToken"} -ContentType "application/json" -Body ("{`"Name`":`"$asocAppName`",`"BusinessImpact`":`"Medium`",`"AssetGroupId`":`"$asocAssetGroupId`",`"BusinessUnitId`":`"00000000-0000-0000-0000-000000000000`",`"TestingStatus`":`"NotStarted`",`"BusinessOwner`":`"`",`"DevelopmentContact`":`"`",`"Tester`":`"`",`"Description`":`"`",`"Technology`":`"`",`"Url`":`"`",`"Hosts`":`"`",`"AutoDeleteExceededScans`":false}") -Uri "https://cloud.appscan.com/api/v2/Apps").content | ConvertFrom-Json).id
	Write-host "The application $asocAppName was created with Id $asocAppId."
	write-output "$asocAppId" > asocAppId_var.txt;
	}

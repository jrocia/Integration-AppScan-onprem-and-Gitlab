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

#$asocApiKeyId='aaaaaaaaaaaaaaaaaaa'
#$asocApiKeySecret='aaaaaaaaaaaaaaaaaaa'
#$asocAppName = 'aaaaaaaaaaaaaaaaaaa'

$asocAppId=(Get-Content .\asocAppId_var.txt);
appscan update
appscan api_login -u $asocApiKeyId -P $asocApiKeySecret -persist
appscan prepare_sca

if ($(Test-Path *.irx) -eq $False){
  Write-host "IRX file not found. Check if there is content to be analyzed.";
  exit 1;
}

appscan queue_analysis -a $asocAppId -n $CI_PROJECT_NAME-$CI_JOB_ID > scanId.txt
$scanId = Get-Content .\scanId.txt -tail 1
$scanStatus = appscan status -i $scanId

while ("$scanStatus" -like "*Running*"){
  $scanStatus = appscan status -i $scanId;
  write-host $scanStatus
  sleep 10
}

appscan get_report -i $scanId -s scan -t security
appscan get_report -i $scanId -s scan -t licenses

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

write-host "======== Step: Publishing Assessment in ASE ========"
# Get the directory where the script is being executed
$scriptDir = $CI_PROJECT_DIR
# Find the first .ozasmt file in the root of the directory
$inputFile = Get-ChildItem -Path $scriptDir -Filter *.ozasmt | Select-Object -First 1
if ($null -eq $inputFile) {
    Write-Error "No .ozasmt file found in directory $scriptDir"
    exit 1
}
# Regular expression to match the variable path segment
$regex = '\\[bB]uilds\\[^\\]+\\\d+\\'
# Read, process, and overwrite the original file
(Get-Content $inputFile.FullName) | ForEach-Object {
    $_ -replace $regex, '\'
} | Set-Content $inputFile.FullName
Write-Host "File successfully updated: $($inputFile.Name)"

# Creating script to get ozasmt scan result
write-output "login_file $aseHostname $aseToken -acceptssl" > scriptpase.scan
write-output "pase $CI_PROJECT_DIR\$aseAppName-$CI_JOB_ID.ozasmt -aseapplication $aseAppName -name $aseAppName-$CI_JOB_ID" >> scriptpase.scan
write-output "exit" >> scriptpase.scan  

# Executing the script
AppScanSrcCli scr scriptpase.scan
# Getting and writing the scanName in a file
$scanName="$aseAppName`-$CI_JOB_ID"
write-output $scanName > scanName_var.txt
write-host "The scan $scanName was published in app $aseAppName in ASE"

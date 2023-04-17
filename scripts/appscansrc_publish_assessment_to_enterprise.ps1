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
# Creating script to get ozasmt scan result
write-output "login_file $aseHostname $aseToken -acceptssl" > scriptpase.scan
write-output "pase $CI_PROJECT_DIR\$CI_PROJECT_NAME-$CI_JOB_ID.ozasmt -aseapplication $aseAppName -name $CI_PROJECT_NAME-$CI_JOB_ID" >> scriptpase.scan
write-output "exit" >> scriptpase.scan  

# Executing the script
AppScanSrcCli scr scriptpase.scan
# Getting and writing the scanName in a file
$scanName="$CI_PROJECT_NAME`-$CI_JOB_ID"
write-output $scanName > scanName_var.txt
write-host "The scan $scanName was published in app $aseAppName in ASE"

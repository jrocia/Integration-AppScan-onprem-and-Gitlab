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
# Publishing scan file into aseAppNAme in AppScan Enterprise
AppScanCMD.exe /r /b $scanFile /rt rc_ase /aan $aseAppName > scanName_var.txt

$outputContent=Get-Content .\scanName_var.txt
$scanName=$outputContent.Replace("`0","") | Select-String -Pattern "AppScan Enterprise job '(.*)'" | % {$_.Matches.Groups[1].Value}
write-host "File $scanFile (scan name $scanName) published on application $aseAppName on AppScan Enterprise." 

sleep 60;

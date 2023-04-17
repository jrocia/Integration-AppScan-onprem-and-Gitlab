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

write-host "======== Step: Creating a config scan file ========"
# Creating Appscan Source script file. It is used with AppScanSrcCli to run scans. It is ready to run scans against java binary files (.jar, .war and .ear). Each language could has a different script. 
write-output "login_file $aseHostname $aseToken -acceptssl" > script.scan
write-output "RUNAS AUTO" >> script.scan
write-output "oa $artifactFolder\$artifactName -appserver_type Tomcat7 -no_ear_project" >> script.scan
write-output "ra $artifactFolder\$artifactName.ozasmt -scanconfig "$scanConfig" -name $artifactName-$CI_JOB_ID" >> script.scan
write-output "report Findings zip $artifactName.zip $artifactFolder\$artifactName.ozasmt -includeSrcBefore:5 -includeSrcAfter:5 -includeTrace:definitive -includeTrace:suspect -includeHowToFix" >> script.scan
write-output "pa $artifactFolder\$artifactName.ozasmt" >> script.scan
write-output "exit" >> script.scan

write-host "Config file created."

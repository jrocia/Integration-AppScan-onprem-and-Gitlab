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

write-host "======== Step: Creating a config scan folder ========"
# Creating Appscan Source script file. It is used with AppScanSrcCli to run scans reading folder content and selecting automatically the language (Open Folder command).
if ($compiledArtifactFolder -ne "none"){
  $content=Get-ChildItem -Path $compiledArtifactFolder -filter "*.zip"
  if ($content){
    write-host "There is a compiled files compressed in folder $compiledArtifactFolder."
    Expand-Archive -Path $content -DestinationPath $compiledArtifactFolder
  }else{
    write-host "There is no compiled files compressed."
  }
  write-output "login_file $aseHostname `"$aseToken`" -acceptssl" > script.scan
  write-output "RUNAS AUTO" >> script.scan
  write-output "of `"$CI_PROJECT_DIR\$compiledArtifactFolder`"" >> script.scan
  write-output "sc `"$aseAppName-$CI_JOB_ID.ozasmt`" -scanconfig `"$scanConfig`" -name `"$aseAppName-$CI_JOB_ID`"" >> script.scan
  write-output "report Findings pdf-detailed `"$aseAppName-$CI_JOB_ID.pdf`" `"$aseAppName-$CI_JOB_ID.ozasmt`" -includeSrcBefore:5 -includeSrcAfter:5 -includeTrace:definitive -includeTrace:suspect -includeHowToFix" >> script.scan
  write-output "pa `"$aseAppName-$CI_JOB_ID.ozasmt`"" >> script.scan
  write-output "exit" >> script.scan
  
  write-host "Config file created for compiled folder ($CI_PROJECT_DIR\$compiledArtifactFolder)."
}
else{
  write-output "login_file $aseHostname `"$aseToken`" -acceptssl" > script.scan
  write-output "RUNAS AUTO" >> script.scan
  write-output "of `"$CI_PROJECT_DIR`"" >> script.scan
  write-output "sc `"$aseAppName-$CI_JOB_ID.ozasmt`" -scanconfig `"$scanConfig`" -name `"$aseAppName-$CI_JOB_ID`" -sourcecodeonly true" >> script.scan
  write-output "report Findings pdf-detailed `"$aseAppName-$CI_JOB_ID.pdf`" `"$aseAppName-$CI_JOB_ID.ozasmt`" -includeSrcBefore:5 -includeSrcAfter:5 -includeTrace:definitive -includeTrace:suspect -includeHowToFix" >> script.scan
  write-output "pa `"$aseAppName-$CI_JOB_ID.ozasmt`"" >> script.scan
  write-output "exit" >> script.scan
  
  write-host "Config file created (source code only scan)."
}

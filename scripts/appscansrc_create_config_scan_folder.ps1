write-host "======== Step: Creating a config scan folder ========"
# Creating Appscan Source script file. It is used with AppScanSrcCli to run scans reading folder content and selecting automatically the language (Open Folder command). 
write-output "login_file $aseHostname $aseToken -acceptssl" > script.scan
write-output "RUNAS AUTO" >> script.scan
write-output "of $artifactFolder" >> script.scan
write-output "sc $artifactFolder\$artifactName.ozasmt -scanconfig "Normal scan" -name $artifactName-$CI_JOB_ID" >> script.scan
write-output "report Findings zip $artifactName.zip $artifactFolder\$artifactName.ozasmt -includeSrcBefore:5 -includeSrcAfter:5 -includeTrace:definitive -includeTrace:suspect -includeHowToFix" >> script.scan
write-output "pa $artifactFolder\$artifactName.ozasmt" >> script.scan
write-output "exit" >> script.scan

write-host "Config file created."

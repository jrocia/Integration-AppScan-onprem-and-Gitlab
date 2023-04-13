write-host "======== Step: Creating a config scan folder ========"
# Creating Appscan Source script file. It is used with AppScanSrcCli to run scans reading folder content and selecting automatically the language (Open Folder command). 
write-output "login" > script.scan
write-output "RUNAS AUTO" >> script.scan
write-output "of `"$CI_PROJECT_DIR`"" >> script.scan
write-output "sc `"$CI_PROJECT_NAME-$CI_JOB_ID.ozasmt`" -scanconfig `"Normal scan`" -name `"$CI_PROJECT_NAME-$CI_JOB_ID`" -sourcecodeonly true" >> script.scan
#write-output "report Findings pdf-detailed `"$CI_PROJECT_NAME-$CI_JOB_ID.pdf`" `"$CI_PROJECT_NAME-$CI_JOB_ID.ozasmt`" -includeSrcBefore:5 -includeSrcAfter:5 -includeTrace:definitive -includeTrace:suspect -includeHowToFix" >> script.scan
write-output "report Findings pdf-detailed `"$CI_PROJECT_NAME-$CI_JOB_ID.pdf`" `"$CI_PROJECT_NAME-$CI_JOB_ID.ozasmt`" -includeSrcBefore:5 -includeSrcAfter:5 -includeTrace:definitive -includeTrace:suspect" >> script.scan
#write-output "pa `"$CI_PROJECT_NAME-$CI_JOB_ID.ozasmt`"" >> script.scan
write-output "exit" >> script.scan

write-host "Config file created."

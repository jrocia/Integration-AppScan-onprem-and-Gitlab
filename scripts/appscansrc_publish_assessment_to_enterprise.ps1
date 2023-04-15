write-host "======== Step: Publishing Assessment in ASE ========"
# Creating script to get ozasmt scan result
if ($compiledArtifactFolder -ne "none"){
  write-output "login_file $aseHostname $aseToken -acceptssl" > scriptpase.scan
  write-output "RUNAS AUTO" >> scriptpase.scan
  write-output "publishassessase $CI_PROJECT_DIR\$compiledArtifactFolder\$CI_PROJECT_NAME-$CI_JOB_ID.ozasmt -aseapplication $aseAppName -name $CI_PROJECT_NAME-$CI_JOB_ID" >> scriptpase.scan
  write-output "exit" >> scriptpase.scan
}
else{
  write-output "login_file $aseHostname $aseToken -acceptssl" > scriptpase.scan
  write-output "RUNAS AUTO" >> scriptpase.scan
  write-output "publishassessase $CI_PROJECT_DIR\$CI_PROJECT_NAME-$CI_JOB_ID.ozasmt -aseapplication $aseAppName -name $CI_PROJECT_NAME-$CI_JOB_ID" >> scriptpase.scan
  write-output "exit" >> scriptpase.scan  
}

# Executing the script
AppScanSrcCli scr scriptpase.scan
# Getting and writing the scanName in a file
$scanName="$CI_PROJECT_NAME`-$CI_JOB_ID"
write-output $scanName > scanName_var.txt
write-host "The scan $scanName was published in app $aseAppName in ASE"

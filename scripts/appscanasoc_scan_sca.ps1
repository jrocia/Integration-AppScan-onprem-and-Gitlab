$asocApiKeyId='aaaaaaaaaaaaaaaaaaa'
$asocApiKeySecret='aaaaaaaaaaaaaaaaaaa'
$asocAppName = 'aaaaaaaaaaaaaaaaaaa'

appscan update
appscan api_login -u $asocApiKeyId -P $asocApiKeySecret -persist
appscan prepare_sca

if ($(Test-Path *.irx) -eq $False){
	Write-host "IRX file not found. Check if there is content to be analyzed.";
	exit 1;
}

appscan queue_analysis -a $asocAppName -n $CI_PROJECT_NAME-$CI_JOB_ID > scanId.txt
$scanId = Get-Content .\scanId.txt -tail 1
$scanStatus = appscan status -i $scanId

while ("$scanStatus" -like "*Running*"){
  $scanStatus = appscan status -i $scanId;
  write-host $scanStatus
  sleep 10
}

appscan get_report -i $scanId -s scan -t security
appscan get_report -i $scanId -s scan -t licenses

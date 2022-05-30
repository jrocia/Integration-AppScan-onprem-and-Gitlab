# Integration AppScan Onprem and Gitlab

Gitlab-CI.YML:
dast-std-gitlab-ci.yml
sast-src-gitlab-ci.yml
dast-std-ase-gitlab-ci.yml
sast-src-ase-gitlab-ci.yml
dast-ase-gitlab-ci.yml


Scripts:
scripts/appscanase_scan.ps1
scripts/appscansrc_scan.ps1
scripts/appscanstd_scan.ps1
scripts/appscanase_create_application_ase.ps1
scripts/appscansrc_create_config_scan_file.ps1
scripts/appscanstd_generate_pdf_report.ps1
scripts/appscansrc_publish_assessment_to_enterprise.ps1
scripts/appscanstd_publish_assessment_to_enterprise.ps1
scripts/appscanase_get_pdf_report_from_enterprise.ps1
scripts/appscanase_get_xml_report_from_enterprise.ps1
scripts/appscanase_convert_ase_dast_xml_to_gitlab_json.ps1
scripts/appscanase_convert_ase_sast_xml_to_gitlab_json.ps1
scripts/appscanase_check_security_gate.ps1
scripts/appscansrc_check_security_gate.ps1
scripts/appscanstd_check_security_gate.ps1

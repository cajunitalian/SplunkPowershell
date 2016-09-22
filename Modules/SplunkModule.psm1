Function Install-Splunk {
Param (
[Parameter(Mandatory=$true)]
[string]$ComputerTarget
) #End Parameters

Process {
	$programfile = "\\$filepath\splunkforwarder.msi" #Replace the MSI and file path with whereever your stuff sits
	Copy-Item -Path $programfile -Destination \\$Computertarget\c$\temp -Verbose

	Start-Sleep -Seconds 2

	Invoke-Command -ComputerName $ComputerTarget -ScriptBlock {
	#Create TEMP Folder if needed
	if (-Not (Test-Path C:\TEMP\)) {
		Write-Host ""
		Write-Host "Temp Folder Doesn't exist, creating folder (C:\TEMP\)" -ForegroundColor Red -BackgroundColor Black
		Write-Host ""
		New-Item -ItemType Directory -Force -Path C:\TEMP\ -Verbose
		} 
		else
		{
	Write-Host ""
	Write-Host "Temp Folder Exists, Proceeding" -ForegroundColor Cyan -BackgroundColor Black
	Write-Host ""
	Start-Sleep -Seconds 2
	}
	#Install Splunk
	$date = get-date -Format M-d-yyyy_THHmm
	$msiArgumentList = "/i C:\TEMP\splunkforwarder.msi /qn AGREETOLICENSE=Yes DEPLOYMENT_SERVER=$SplunkDepServer:8089 /L*V C:\TEMP\SplunkInstall_$date.log"
	Start-Process msiexec -ArgumentList $msiArgumentList -Wait -Verbose
	#Cleanup
	Remove-Item C:\TEMP\splunkforwarder.msi -Verbose
	} #End Script
		} #End Process
			} #End Function

###

Function Uninstall-Splunk {
Param (
[Parameter(Mandatory=$true)]
[string]$ComputerTarget
) #End Parameters

Process {
	$programfile = "\\$filepath\splunkforwarder.msi" #Replace the MSI and file path with whereever your stuff sits
	Copy-Item -Path $programfile -Destination \\$ComputerTarget\c$\temp -Verbose

	Start-Sleep -Seconds 2

	Invoke-Command -ComputerName $ComputerTarget -ScriptBlock {
	#Create TEMP Folder if needed
	if (-Not (Test-Path C:\TEMP\)) {
		Write-Host ""
		Write-Host "Temp Folder Doesn't exist, creating folder (C:\TEMP\)" -ForegroundColor Red -BackgroundColor Black
		Write-Host ""
		New-Item -ItemType Directory -Force -Path C:\TEMP\ -Verbose
		} 
		else
		{
	Write-Host ""
	Write-Host "Temp Folder Exists, Proceeding" -ForegroundColor Cyan -BackgroundColor Black
	Write-Host ""
	Start-Sleep -Seconds 2
	}
	#uninstall Splunk
	$date = get-date -Format M-d-yyyy_THHmm
	$msiArgumentList = "/x C:\TEMP\splunkforwarder.msi /L*V C:\TEMP\SplunkUninstall_$date.log"
	Start-Process msiexec -ArgumentList $msiArgumentList -Wait -Verbose
	#Cleanup
	Remove-Item C:\TEMP\splunkforwarder.msi -Verbose
	} #End Script
		} #End Process
			} #End Function

###

Function Get-SplunkInstall {
Param (
[Parameter(Mandatory=$true)]
[string]$ComputerTarget
) #End Parameters

Process {
	if (-Not (Get-Service -ComputerName $ComputerTarget *Splunk* -Verbose)) {
	Write-Host "Splunk Service is Not Installed on $ComputerTarget"
	}
	else
	{
	Write-Host "Splunk Service is Installed on $ComputerTarget"
	}
} #End Process
} #End Function
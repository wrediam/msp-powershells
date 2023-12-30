Invoke-WebRequest "https://raw.githubusercontent.com/wrediam/msp-powershells/main/Set-LogonMessage/Set-LogonMessage.ps1" -OutFile c:\Set-LogonMessage.ps1
c:\Set-LogonMessage.ps1 -Title "Wredia Co. LLC is your MSP" -Message "For support, please contact support@wredia.com"
Remove-Item -Path c:\Set-LogonMessage.ps1
Invoke-Expression "gpupdate /force"
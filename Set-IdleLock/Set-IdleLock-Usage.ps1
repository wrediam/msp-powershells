Invoke-WebRequest "https://raw.githubusercontent.com/wrediam/msp-powershells/main/Set-IdleLock/Set-IdleLock.ps1" -OutFile c:\Set-IdleLock.ps1
c:\Set-IdleLock.ps1 -Minutes 5
Remove-Item -Path c:\Set-IdleLock.ps1
Invoke-Expression "gpupdate /force"
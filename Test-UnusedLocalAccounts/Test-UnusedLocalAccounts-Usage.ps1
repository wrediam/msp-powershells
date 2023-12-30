Invoke-WebRequest "https://raw.githubusercontent.com/wrediam/msp-powershells/main/Test-UnusedLocalAccounts/Test-UnusedLocalAccounts.ps1" -OutFile c:\Test-UnusedLocalAccounts.ps1
c:\Test-UnusedLocalAccounts.ps1 -Days 30
Remove-Item -Path c:\Test-UnusedLocalAccounts.ps1
Invoke-Expression "gpupdate /force"
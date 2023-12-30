Invoke-WebRequest "https://raw.githubusercontent.com/wrediam/msp-powershells/main/Disable-LocalAccount/Disable-LocalAccount.ps1" -OutFile c:\Disable-LocalAccount.ps1
c:\Disable-LocalAccount.ps1 -UserName "Administrator"
Remove-Item -Path c:\Disable-LocalAccount.ps1
Invoke-Expression "gpupdate /force"
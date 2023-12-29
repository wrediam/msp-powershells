#Requires -Version 5.1

<#
.SYNOPSIS
    Set the Inactivity(Lock Computer) timeout time if it already isn't set.
.DESCRIPTION
    Set the Inactivity(Lock Computer) timeout time if it already isn't set.
    Can be set regardless if the -Force parameter is used.
.EXAMPLE
     -Minutes 5
    This set the Inactivity(Lock Computer) timeout to 5 minutes, does not change if already set.
.EXAMPLE
     -Minutes 5 -Force
    This set the Inactivity(Lock Computer) timeout to 5 minutes, and forces the change if already set.
.EXAMPLE
    PS C:\> Set-IdleLock.ps1 -Minutes 5
    This set the Inactivity(Lock Computer) timeout to 5 minutes
.OUTPUTS
    None
.NOTES
    Minimum OS Architecture Supported: Windows 10, Windows Server 2016
    Release Notes: Renamed script and added Script Variable support, updated Set-ItemProp
By using this script, you indicate your acceptance of the following legal terms as well as our Terms of Use at https://www.ninjaone.com/terms-of-use.
    Ownership Rights: NinjaOne owns and will continue to own all right, title, and interest in and to the script (including the copyright). NinjaOne is giving you a limited license to use the script in accordance with these legal terms. 
    Use Limitation: You may only use the script for your legitimate personal or internal business purposes, and you may not share the script with another party. 
    Republication Prohibition: Under no circumstances are you permitted to re-publish the script in any script library or website belonging to or under the control of any other software provider. 
    Warranty Disclaimer: The script is provided “as is” and “as available”, without warranty of any kind. NinjaOne makes no promise or guarantee that the script will be free from defects or that it will meet your specific needs or expectations. 
    Assumption of Risk: Your use of the script is at your own risk. You acknowledge that there are certain inherent risks in using the script, and you understand and assume each of those risks. 
    Waiver and Release: You will not hold NinjaOne responsible for any adverse or unintended consequences resulting from your use of the script, and you waive any legal or equitable rights or remedies you may have against NinjaOne relating to your use of the script. 
    EULA: If you are a NinjaOne customer, your use of the script is subject to the End User License Agreement applicable to you (EULA).
.COMPONENT
    LocalUserAccountManagement
#>

[CmdletBinding()]
param (
    [Parameter()]
    [int]$Minutes,
    [switch]$Force = [System.Convert]::ToBoolean($env:force)
)

begin {
    if ($env:minutes -and $env:minutes -notlike "null") {
        $Minutes = $env:minutes
    }
    
    if(-not ($Minutes)){
        Write-Error "Minutes is required!"
        exit 1
    }

    if($Minutes -gt 9999 -or $Minutes -lt 0){
        Write-Error "Minutes must be between 0 and 9999 (including 0 and 9999)."
        exit 1
    }

    function Test-IsElevated {
        $id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
        $p = New-Object System.Security.Principal.WindowsPrincipal($id)
        if ($p.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator))
        { Write-Output $true }
        else
        { Write-Output $false }
    }
    function Set-ItemProp {
        param (
            $Path,
            $Name,
            $Value,
            [ValidateSet("DWord", "QWord", "String", "ExpandedString", "Binary", "MultiString", "Unknown")]
            $PropertyType = "DWord"
        )
        # Do not output errors and continue
        $ErrorActionPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue
        if (-not $(Test-Path -Path $Path)) {
            # Check if path does not exist and create the path
            New-Item -Path $Path -Force | Out-Null
        }
        if ((Get-ItemProperty -Path $Path -Name $Name)) {
            # Update property and print out what it was changed from and changed to
            $CurrentValue = Get-ItemProperty -Path $Path -Name $Name
            try {
                Set-ItemProperty -Path $Path -Name $Name -Value $Value -Force -Confirm:$false -ErrorAction Stop | Out-Null
            }
            catch {
                Write-Error $_
            }
            Write-Host "$Path\$Name changed from $CurrentValue to $(Get-ItemProperty -Path $Path -Name $Name)"
        }
        else {
            # Create property with value
            try {
                New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType $PropertyType -Force -Confirm:$false -ErrorAction Stop | Out-Null
            }
            catch {
                Write-Error $_
            }
            Write-Host "Set $Path$Name to $(Get-ItemProperty -Path $Path -Name $Name)"
        }
        $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Continue
    }
}
process {
    if (-not (Test-IsElevated)) {
        Write-Error -Message "Access Denied. Please run with Administrator privileges."
        exit 1
    }
    
    $Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
    $IdleName = "InactivityTimeoutSecs"
    $Seconds = $Minutes * 60
    # Override "Check if already set"
    if (-not $Force) {
        # Check if already set
        if ($(Get-ItemProperty -Path $Path | Select-Object -Property $IdleName -ExpandProperty $IdleName -ErrorAction SilentlyContinue)) {
            $CurrentIdleSeconds = $(Get-ItemPropertyValue -Path $Path -Name $IdleName)
            # If value already set, do nothing.
            if ($CurrentIdleSeconds) { exit 0 }
        }
    }

    # Sets InactivityTimeoutSecs to $Minutes
    try {
        Set-ItemProp -Path $Path -Name $IdleName -Value $Seconds
        Write-Host "Set the Inactivity to $($Seconds/60) minutes."
    }
    catch {
        Write-Error $_
        exit 1
    }
}
end {
    
    
    
}
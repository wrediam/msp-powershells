$profilesToDelete = Get-WMIObject -class Win32_UserProfile | Where {(!$_.Special) -and ($_.ConvertToDateTime($_.LastUseTime) -lt (Get-Date).AddDays(-365))}

if ($profilesToDelete) {
    $profilesToDelete | ForEach-Object {
        $profileInfo = $_.LocalPath
        $_ | Remove-WmiObject
        Write-Output "Deleted profile: $profileInfo"
    }
} else {
    Write-Output "No profiles were deleted."
}
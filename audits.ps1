$path = "C:\Users\parad\OneDrive\Dokumenty\GitHub\Workshop-part-4\network_configs"
$now = Get-Date
Write-Host "Date:" $now
$files = Get-ChildItem -Path $path -Recurse -File
Write-Host "Files found:" $files.Count

#___FILE SUMMARY___
Write-Host "`nFile summary by type"
$fileGroups = $files | Group-Object -Property Extension
foreach ($group in $fileGroups) {
    $ext = $group.Name
    $count = $group.Count
    Write-Host "$ext : $count files"
}
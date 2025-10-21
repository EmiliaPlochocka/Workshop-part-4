$path = "C:\Users\parad\OneDrive\Dokumenty\GitHub\Workshop-part-4\network_configs"
$now = Get-Date
$weekAgo = $now.AddDays(-7)

Write-Host "Date: $now"

#___DISPLAY FILENAME, LENGTH AND EDIT___
$files = Get-ChildItem -Path $path -Recurse -Include *.conf, *.rules, *.log -ErrorAction SilentlyContinue
Write-Host "`nFiles found:" $files.Count
$files | Select-Object Name, Length, LastWriteTime | Format-Table

#___FILES CHANGED IN LAST 7 DAYS___
Write-Host "Files edited over the last 7 days:"
Get-ChildItem -Path "network_configs" -Recurse -File | Where-Object { $_.LastWriteTime -gt $weekAgo } 
| Sort-Object LastWriteTime -Descending | Select-Object Name, LastWriteTime 
| Format-Table -AutoSize

#___GROUP FILE EXTENSIONS___
Write-Host "`nFile extensions:"
Get-ChildItem -Path "network_configs" -Recurse -file | Group-Object Extension 
| Select-Object Name, count, @{Name = "TotalSize_MB"; Expression = { [math]::Round(($_.Group | Measure-Object Length -Sum).Sum / 1MB, 2) } } |
Format-Table -AutoSize

#___LIST 5 LARGEST FILES___
Write-Host "`nFive largest files: "
Get-ChildItem -Path "network_configs" -Recurse -Filter "*.log" | Sort-Object Length -Descending 
| Select-Object -first 5 Name, @{Name = "Size_MB"; Expression = { [math]::Round($_.Length / 1MB, 2) } }, LastWriteTime
| Format-Table -AutoSize

$ipPattern = '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}'
$ipAddresses = Get-ChildItem -Path "network_configs" -Recurse -Filter "*.conf" |
Select-String -Pattern $ipPattern |
ForEach-Object { $_.Matches.Value } |
Sort-Object -Unique
Write-Host "`nUnique IP addresses: $($ipAddresses.Count)"
$ipAddresses | ForEach-Object { Write-Host $_ }
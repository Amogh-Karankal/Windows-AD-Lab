# Get-ADReport.ps1
# Generates a report of all users, groups, and locked accounts
# Usage: .\Get-ADReport.ps1

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "       ACTIVE DIRECTORY REPORT           " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

Write-Host "`n[ORGANIZATIONAL UNITS]" -ForegroundColor Yellow
Get-ADOrganizationalUnit -Filter * | 
    Select-Object Name | 
    Format-Table -AutoSize

Write-Host "`n[ALL DOMAIN USERS]" -ForegroundColor Yellow
Get-ADUser -Filter * -Properties Department, Created | 
    Select-Object Name, SamAccountName, Enabled, Created | 
    Format-Table -AutoSize

Write-Host "`n[SECURITY GROUPS]" -ForegroundColor Yellow
Get-ADGroup -Filter {GroupCategory -eq "Security"} -SearchBase "OU=Groups,DC=amoghlab,DC=local" | 
    Select-Object Name, GroupScope | 
    Format-Table -AutoSize

Write-Host "`n[GROUP MEMBERSHIPS]" -ForegroundColor Yellow
$Groups = Get-ADGroup -Filter * -SearchBase "OU=Groups,DC=amoghlab,DC=local"
foreach ($Group in $Groups) {
    $Members = Get-ADGroupMember -Identity $Group.Name -ErrorAction SilentlyContinue
    Write-Host "  $($Group.Name):" -ForegroundColor Cyan
    if ($Members) {
        $Members | ForEach-Object { Write-Host "    - $($_.Name)" }
    } else {
        Write-Host "    (empty)" -ForegroundColor Gray
    }
}

Write-Host "`n[LOCKED OUT ACCOUNTS]" -ForegroundColor Yellow
$Locked = Search-ADAccount -LockedOut
if ($Locked) {
    $Locked | Select-Object Name, SamAccountName | Format-Table -AutoSize
} else {
    Write-Host "  None" -ForegroundColor Green
}

Write-Host "`n[DISABLED ACCOUNTS]" -ForegroundColor Yellow
$Disabled = Get-ADUser -Filter {Enabled -eq $false}
if ($Disabled) {
    $Disabled | Select-Object Name, SamAccountName | Format-Table -AutoSize
} else {
    Write-Host "  None" -ForegroundColor Green
}

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "         END OF REPORT                   " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

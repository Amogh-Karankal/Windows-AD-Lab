# Disable-OffboardUser.ps1
# Disables user, removes from groups, moves to Disabled_Accounts OU
# Usage: .\Disable-OffboardUser.ps1 -Username "john.smith"

param(
    [Parameter(Mandatory=$true)]
    [string]$Username
)

try {
    # Get user
    $User = Get-ADUser -Identity $Username -Properties MemberOf
    
    if (-not $User) {
        Write-Host "User not found!" -ForegroundColor Red
        return
    }
    
    Write-Host "Processing offboard for: $($User.Name)" -ForegroundColor Yellow
    
    # Step 1: Disable account
    Disable-ADAccount -Identity $Username
    Write-Host "  [1/3] Account disabled" -ForegroundColor Green
    
    # Step 2: Remove from all groups (except Domain Users)
    $Groups = Get-ADPrincipalGroupMembership -Identity $Username | 
              Where-Object {$_.Name -ne "Domain Users"}
    
    foreach ($Group in $Groups) {
        Remove-ADGroupMember -Identity $Group -Members $Username -Confirm:$false
        Write-Host "  - Removed from: $($Group.Name)" -ForegroundColor Gray
    }
    Write-Host "  [2/3] Removed from all groups" -ForegroundColor Green
    
    # Step 3: Move to Disabled_Accounts OU
    $TargetOU = "OU=Disabled_Accounts,DC=amoghlab,DC=local"
    Move-ADObject -Identity $User.DistinguishedName -TargetPath $TargetOU
    Write-Host "  [3/3] Moved to Disabled_Accounts OU" -ForegroundColor Green
    
    Write-Host "`nOffboarding complete for $Username!" -ForegroundColor Cyan
}
catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

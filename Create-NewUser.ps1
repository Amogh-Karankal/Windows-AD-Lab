# Create-NewUser.ps1
# Creates a new AD user in the specified department OU
# Usage: .\Create-NewUser.ps1 -FirstName "John" -LastName "Doe" -Department "IT"

param(
    [Parameter(Mandatory=$true)]
    [string]$FirstName,
    
    [Parameter(Mandatory=$true)]
    [string]$LastName,
    
    [Parameter(Mandatory=$true)]
    [ValidateSet("IT","HR","Finance")]
    [string]$Department
)

$Username = "$FirstName.$LastName".ToLower()
$Password = ConvertTo-SecureString "Welcome@123!" -AsPlainText -Force

try {
    New-ADUser `
        -Name "$FirstName $LastName" `
        -GivenName $FirstName `
        -Surname $LastName `
        -SamAccountName $Username `
        -UserPrincipalName "$Username@amoghlab.local" `
        -Path "OU=$Department,DC=amoghlab,DC=local" `
        -AccountPassword $Password `
        -Enabled $true `
        -ChangePasswordAtLogon $true

    Write-Host "Created user: $Username in $Department OU" -ForegroundColor Green
    Write-Host "   Temporary Password: Welcome@123!" -ForegroundColor Yellow
}
catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

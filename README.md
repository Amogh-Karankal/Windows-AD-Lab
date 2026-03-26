# Windows Server Active Directory Lab

Hands-on Active Directory Domain Services (AD DS) lab built on Windows Server 2022, demonstrating enterprise identity management, organizational structure, Group Policy administration, and PowerShell automation.

![Windows Server](https://img.shields.io/badge/Windows%20Server-2022-blue?logo=windows)
![Active Directory](https://img.shields.io/badge/Active%20Directory-Domain%20Services-green)
![PowerShell](https://img.shields.io/badge/PowerShell-Automation-blue?logo=powershell)
![Oracle Cloud](https://img.shields.io/badge/Oracle%20Cloud-Free%20Tier-red)

## 🎯 Overview

This project demonstrates core Active Directory administration skills including domain controller deployment, organizational unit design, user/group management, Group Policy implementation, and PowerShell automation for common IT tasks.

### Skills Demonstrated

- Windows Server 2022 installation and configuration
- Active Directory Domain Services (AD DS) deployment
- Domain Controller promotion and management
- Organizational Unit (OU) structure design
- User account provisioning and management
- Security group creation and membership management
- Group Policy Objects (GPOs) for security enforcement
- PowerShell scripting for AD automation
- OU delegation for least-privilege administration
- DNS Server configuration (integrated with AD)

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Oracle Cloud Infrastructure              │
│                                                             │
│   ┌─────────────────────────────────────────────────────┐   │
│   │           Windows Server 2022 VM                    │   │
│   │           (VM.Standard.E2.1)                        │   │
│   │                                                     │   │
│   │   ┌─────────────────────────────────────────────┐   │   │
│   │   │         Active Directory Domain             │   │   │
│   │   │            amoghlab.local                   │   │   │
│   │   │                                             │   │   │
│   │   │   Roles:                                    │   │   │
│   │   │   • AD Domain Services                      │   │   │
│   │   │   • DNS Server                              │   │   │
│   │   │   • Global Catalog                          │   │   │
│   │   └─────────────────────────────────────────────┘   │   │
│   │                                                     │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## 📁 Active Directory Structure

```
amoghlab.local (Domain)
│
├── IT (OU)
│   ├── John Smith (john.smith)
│   └── Sarah Tech (sarah.tech)
│
├── HR (OU)
│   └── Mike Human (mike.human)
│
├── Finance (OU)
│   └── Lisa Money (lisa.money)
│
├── Disabled_Accounts (OU)
│   └── (For offboarded users)
│
└── Groups (OU)
    ├── IT_Admins (Security Group)
    ├── HR_Staff (Security Group)
    ├── Finance_Staff (Security Group)
    └── VPN_Users (Security Group)
```

## 👥 User Accounts

| Username | Full Name | Department | Groups |
|----------|-----------|------------|--------|
| john.smith | John Smith | IT | IT_Admins, VPN_Users |
| sarah.tech | Sarah Tech | IT | IT_Admins |
| mike.human | Mike Human | HR | HR_Staff, VPN_Users |
| lisa.money | Lisa Money | Finance | Finance_Staff, VPN_Users |

## 🔐 Security Groups

| Group Name | Type | Scope | Purpose |
|------------|------|-------|---------|
| IT_Admins | Security | Global | IT department administrators |
| HR_Staff | Security | Global | HR department employees |
| Finance_Staff | Security | Global | Finance department employees |
| VPN_Users | Security | Global | Users with VPN access |

## 📋 Group Policy Objects

### 1. Password Policy (Domain-Wide)

**Linked to:** amoghlab.local (entire domain)

| Setting | Value |
|---------|-------|
| Minimum password length | 12 characters |
| Password complexity | Enabled |

**Path:** Computer Configuration → Policies → Windows Settings → Security Settings → Account Policies → Password Policy

### 2. Account Lockout Policy (Domain-Wide)

**Linked to:** amoghlab.local (entire domain)

| Setting | Value |
|---------|-------|
| Account lockout threshold | 5 invalid attempts |
| Account lockout duration | 30 minutes |
| Reset lockout counter after | 30 minutes |

**Path:** Computer Configuration → Policies → Windows Settings → Security Settings → Account Policies → Account Lockout Policy

### 3. Audit Policy (Domain-Wide)

**Linked to:** amoghlab.local (entire domain)

| Setting | Value |
|---------|-------|
| Audit Logon | Success and Failure |
| Audit Logoff | Success |
| Audit Account Lockout | Success and Failure |

**Path:** Computer Configuration → Policies → Windows Settings → Security Settings → Advanced Audit Policy Configuration → Logon/Logoff

### 4. Restrict Control Panel (HR Department)

**Linked to:** HR OU only

| Setting | Value |
|---------|-------|
| Prohibit access to Control Panel | Enabled |

**Path:** User Configuration → Policies → Administrative Templates → Control Panel

### 5. Block USB Storage (Finance Department)

**Linked to:** Finance OU only

| Setting | Value |
|---------|-------|
| All Removable Storage classes: Deny all access | Enabled |

**Path:** Computer Configuration → Policies → Administrative Templates → System → Removable Storage Access

This demonstrates defense-in-depth: domain-wide security baselines plus targeted restrictions for sensitive departments.

## 🔐 OU Delegation

Implemented least-privilege administration:

| OU | Delegated To | Permission |
|----|--------------|------------|
| IT | HR_Staff | Reset user passwords |

This allows helpdesk staff to reset passwords without full admin rights — a real-world security best practice.

## 🚀 Deployment Steps

### Phase 1: Infrastructure Setup

1. Created Oracle Cloud Free Tier account
2. Deployed Windows Server 2022 VM (VM.Standard.E2.1)
3. Configured networking with public IP
4. Connected via Remote Desktop (RDP)

### Phase 2: Active Directory Installation

1. Installed AD DS role via Server Manager
2. Promoted server to Domain Controller
3. Created new forest: `amoghlab.local`
4. Configured DNS (integrated with AD)

### Phase 3: Directory Structure

1. Created Organizational Units (OUs) for departments
2. Created user accounts in appropriate OUs
3. Created security groups in Groups OU
4. Assigned users to appropriate groups

### Phase 4: Group Policy

1. Created Password Policy GPO (domain-wide)
2. Created Account Lockout Policy GPO (domain-wide)
3. Created Audit Policy GPO (domain-wide)
4. Created Restrict Control Panel GPO (HR OU)
5. Created Block USB Storage GPO (Finance OU)

### Phase 5: Delegation & Automation

1. Delegated password reset to HR_Staff for IT OU
2. Created PowerShell scripts for AD automation

## 💻 PowerShell Automation Scripts

### Create-NewUser.ps1

Automates user provisioning with department-based OU placement.

```powershell
.\Create-NewUser.ps1 -FirstName "John" -LastName "Doe" -Department "IT"
```

**Features:**
- Creates user in correct OU based on department
- Sets temporary password with forced change at logon
- Validates department input (IT, HR, Finance)

### Get-ADReport.ps1

Generates comprehensive AD report.

```powershell
.\Get-ADReport.ps1
```

**Output includes:**
- All Organizational Units
- All domain users with status
- Security groups and memberships
- Locked out accounts
- Disabled accounts

### Disable-OffboardUser.ps1

Automates employee offboarding process.

```powershell
.\Disable-OffboardUser.ps1 -Username "john.doe"
```

**Actions performed:**
1. Disables the account
2. Removes from all security groups
3. Moves to Disabled_Accounts OU

## 📸 Screenshots

| Screenshot | Description |
|------------|-------------|
| [AD Users and Computers](screenshots/01-OU.png) | Full AD structure |
| [User Accounts](screenshots/02-IT-users.png) | Created users |
| [Security Groups](screenshots/03-Groups.png) | Security groups |
| [Group Membership](screenshots/04-IT-admins-members.png) | Users in groups |
| [GPO Console](screenshots/05-GPO.png) | Group Policy Management |
| [Password Policy](screenshots/06-Password-GPO.png) | Password GPO settings |
| [Control Panel GPO](screenshots/11-ControlPanel-GPO.png) | Restriction GPO |

## 🛠️ Technologies Used

- **Operating System:** Windows Server 2022 Standard
- **Directory Services:** Active Directory Domain Services (AD DS)
- **DNS:** Windows DNS Server (AD-integrated)
- **Cloud Provider:** Oracle Cloud Infrastructure (Free Tier)
- **Remote Access:** Remote Desktop Protocol (RDP)

## 📚 Key Concepts Demonstrated

### Organizational Units (OUs)
- Logical containers for organizing AD objects
- Enable delegation of administration
- Allow targeted Group Policy application

### Security Groups
- Used for assigning permissions
- Global scope for domain-wide use
- Security type for access control

### Group Policy Objects (GPOs)
- Centralized configuration management
- Can be linked at domain, site, or OU level
- Inheritance flows down the AD hierarchy

## 🔧 Common AD Administration Tasks

```powershell
# View all users in domain
Get-ADUser -Filter * | Select-Object Name, SamAccountName

# View all groups
Get-ADGroup -Filter * | Select-Object Name, GroupScope

# View group membership
Get-ADGroupMember -Identity "IT_Admins"

# Create new user
New-ADUser -Name "New User" -SamAccountName "new.user" -Path "OU=IT,DC=amoghlab,DC=local"

# Add user to group
Add-ADGroupMember -Identity "VPN_Users" -Members "new.user"

# Force Group Policy update
gpupdate /force
```

## 📈 Future Enhancements

- [ ] Add second Domain Controller for redundancy
- [ ] Implement DHCP Server role
- [ ] Configure additional GPOs (drive mappings, logon scripts)
- [ ] Set up fine-grained password policies
- [ ] Implement OU delegation

## 👤 Author

**Amogh Karankal**

- GitHub: [@Amogh-Karankal](https://github.com/Amogh-Karankal)
- LinkedIn: [Amogh Karankal](https://www.linkedin.com/in/amoghkarankal/)

## 📄 License

This project is licensed under the MIT License.

---

*Built as part of IT helpdesk/sysadmin skill development*

# Windows Server Active Directory Lab

Hands-on Active Directory Domain Services (AD DS) lab built on Windows Server 2022, demonstrating enterprise identity management, organizational structure, Group Policy administration, and PowerShell automation.

![Windows Server](https://img.shields.io/badge/Windows%20Server-2022-blue?logo=windows)
![Active Directory](https://img.shields.io/badge/Active%20Directory-Domain%20Services-green)
![PowerShell](https://img.shields.io/badge/PowerShell-Automation-blue?logo=powershell)
![Oracle Cloud](https://img.shields.io/badge/Oracle%20Cloud-Free%20Tier-red)

## 🎯 Overview

This project demonstrates core Active Directory administration skills including domain controller deployment, organizational unit design, user/group management, Group Policy implementation, advanced GPO configurations, and PowerShell automation for common IT tasks.

### Skills Demonstrated

- Windows Server 2022 installation and configuration
- Active Directory Domain Services (AD DS) deployment
- Domain Controller promotion and management
- Organizational Unit (OU) structure design
- User account provisioning and management
- Security group creation and membership management
- Group Policy Objects (GPOs) for security enforcement
- Fine-grained password policies (PSOs) for privileged accounts
- GPO blocked inheritance and enforcement
- Loopback policy processing (Replace mode)
- WMI filtering for targeted GPO application
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
├── IT (OU) ← Block Inheritance + Loopback Policy applied
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

### 6. Security Baseline Enforced (Domain-Wide, Enforced)

**Linked to:** amoghlab.local with **Enforced** flag set

This GPO is configured with enforcement, meaning it applies to all OUs including those with blocked inheritance. Used to demonstrate GPO precedence and enforcement behavior.

| Setting | Value |
|---------|-------|
| All Removable Storage classes: Deny all access | Enabled |
| WMI Filter | Filter-Windows-Server-2022 |

## 🔒 Advanced GPO Configurations

### Fine-Grained Password Policy (PSO)

Standard domain password policies apply uniformly to all users. Fine-grained password policies (Password Settings Objects) allow different password rules for specific users or groups — a real-world requirement for privileged accounts.

**PSO-Admins** — applied to `Domain Admins` group:

| Setting | Value |
|---------|-------|
| Minimum password length | 16 characters |
| Password history | 24 passwords |
| Maximum password age | 60 days |
| Lockout threshold | 3 attempts |
| Lockout duration | 30 minutes |
| Complexity | Enabled |
| Reversible encryption | Disabled |
| Precedence | 10 (overrides Default Domain Policy) |

**Verified via PowerShell:**
```powershell
Get-ADFineGrainedPasswordPolicy -Identity "PSO-Admins"
Get-ADUserResultantPasswordPolicy -Identity Administrator
```
`Get-ADUserResultantPasswordPolicy` confirms the Administrator account receives PSO-Admins settings instead of the Default Domain Policy — proof that fine-grained policy precedence is working correctly.

---

### GPO Blocked Inheritance + Enforcement

**Blocked Inheritance** prevents an OU from inheriting GPOs linked at parent levels. **Enforcement** overrides blocked inheritance for critical policies — demonstrating how admins balance OU autonomy with mandatory security baselines.

**Configuration:**
- Block inheritance applied to: `IT` OU
- `Security-Baseline-Enforced` GPO linked at domain root with **Enforced** flag

**Verified via Group Policy Modeling:**

GPMC Group Policy Modeling confirms: *"Inheritance is blocking all non-enforced GPOs linked above amoghlab.local/IT"* — proving the block is active while enforced GPOs still apply.

---

### Loopback Policy (Replace Mode)

Normally, User Configuration settings apply based on where the **user account** lives in AD. Loopback policy changes this — it applies User Configuration based on where the **computer** is located. Used for shared workstations, kiosk machines, and RDS servers.

**GPO:** `Loopback-IT-Policy` — linked to `IT` OU

| Setting | Value |
|---------|-------|
| Loopback processing mode | Replace |
| User Config: Control Panel access | Prohibited |

**Replace mode** means only the computer OU's user settings apply — the user's own GPOs are completely replaced. This ensures consistent lockdown regardless of which user logs in.

**Verified via Group Policy Modeling:**

Modeling result for `sarah.tech` logging into `IT-WORKSTATION01` (IT OU):
- `Loopback-IT-Policy` appears in Applied GPOs
- Control Panel prohibition shown as active under User Details → Settings → Winning GPO: `Loopback-IT-Policy`

---

### WMI Filtering

WMI filters allow conditional GPO application based on a machine's properties (OS version, hardware specs, etc.). The GPO only applies if the WMI query returns true — preventing misapplication across mixed OS environments.

**Filter:** `Filter-Windows-Server-2022`

```sql
SELECT * FROM Win32_OperatingSystem WHERE Caption LIKE "%Windows Server 2022%"
```

**Linked to:** `Security-Baseline-Enforced` GPO

**Verified via PowerShell:**
```powershell
# Confirms WMI filter is linked to the GPO
Get-GPO -Name "Security-Baseline-Enforced" | Select-Object DisplayName, WmiFilter

# Confirms this machine matches the filter (will evaluate to true)
Get-WmiObject Win32_OperatingSystem | Select-Object Caption
# Output: Microsoft Windows Server 2022 Standard
```

## 🔐 OU Delegation

Implemented least-privilege administration:

| OU | Delegated To | Permission |
|----|-------------|------------|
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
6. Created Security-Baseline-Enforced GPO with WMI filter

### Phase 5: Advanced GPO Configurations

1. Created PSO-Admins fine-grained password policy for Domain Admins
2. Applied blocked inheritance to IT OU
3. Configured Security-Baseline-Enforced with Enforced flag at domain root
4. Created Loopback-IT-Policy in Replace mode linked to IT OU
5. Created WMI filter for Windows Server 2022 and linked to Security-Baseline-Enforced

### Phase 6: Delegation & Automation

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
| [PSO Verification](screenshots/12-PSO-Admins.png) | Fine-grained password policy output |
| [Blocked Inheritance](screenshots/13-blocked-inheritance.png) | IT OU with inheritance blocked (GPMC modeling) |
| [Loopback Policy](screenshots/14-loopback-policy.png) | Loopback Replace mode — Winning GPO confirmed |
| [WMI Filter](screenshots/15-WMI-Filter.png) | WMI filter linked to GPO + OS verification |

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
- Enforcement overrides blocked inheritance for critical policies

### Advanced GPO Concepts
- **Fine-grained password policies** — per-group password rules using PSOs
- **Blocked inheritance** — OU-level isolation from parent GPOs
- **Enforcement** — mandatory policies that override inheritance blocks
- **Loopback processing** — computer-based user policy application
- **WMI filtering** — conditional GPO application based on machine properties

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

# Check resultant password policy for a user
Get-ADUserResultantPasswordPolicy -Identity Administrator

# Force Group Policy update
gpupdate /force

# Generate GPO report
gpresult /r
```

## 📈 Future Enhancements

- Add second Domain Controller for redundancy
- Implement DHCP Server role
- Configure drive mappings and logon scripts via GPO
- CIS security hardening baseline

## 👤 Author

**Amogh Karankal**

- GitHub: [@Amogh-Karankal](https://github.com/Amogh-Karankal)
- LinkedIn: [Amogh Karankal](https://www.linkedin.com/in/amoghkarankal/)

## 📄 License

This project is licensed under the MIT License.

---

*Built as part of IT helpdesk/sysadmin skill development*

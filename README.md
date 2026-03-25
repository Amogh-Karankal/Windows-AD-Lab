# Windows Server Active Directory Lab

Hands-on Active Directory Domain Services (AD DS) lab built on Windows Server 2022, demonstrating enterprise identity management, organizational structure, and Group Policy administration.

![Windows Server](https://img.shields.io/badge/Windows%20Server-2022-blue?logo=windows)
![Active Directory](https://img.shields.io/badge/Active%20Directory-Domain%20Services-green)
![Oracle Cloud](https://img.shields.io/badge/Oracle%20Cloud-Free%20Tier-red)

## 🎯 Overview

This project demonstrates core Active Directory administration skills including domain controller deployment, organizational unit design, user/group management, and Group Policy implementation.

### Skills Demonstrated

- Windows Server 2022 installation and configuration
- Active Directory Domain Services (AD DS) deployment
- Domain Controller promotion and management
- Organizational Unit (OU) structure design
- User account provisioning and management
- Security group creation and membership management
- Group Policy Object (GPO) creation and linking
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

### 2. Restrict Control Panel (HR Department)

**Linked to:** HR OU only

| Setting | Value |
|---------|-------|
| Prohibit access to Control Panel | Enabled |

**Path:** User Configuration → Policies → Administrative Templates → Control Panel

This demonstrates applying different policies to different organizational units.

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

1. Created Password Policy GPO
2. Linked Password Policy to domain
3. Created Restrict Control Panel GPO
4. Linked restriction to HR OU only

## 📸 Screenshots

| Screenshot | Description |
|------------|-------------|
| [OU Structure](screenshots/01-OU.png) | Organizational Units |
| [User Accounts](screenshots/02-IT-users.png) | Created users |
| [Security Groups](screenshots/03-Groups.png) | Security groups |
| [Group Membership](screenshots/04-IT-admins-members.png) | Users in groups |
| [GPO Console](screenshots/05-GPO.png) | Group Policy Management |
| [Password Policy](screenshots/06-Password-GPO.png) | Password GPO settings |
| [Control Panel GPO](screenshots/07-linkedGPO-HR.png) | Restriction GPO |

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

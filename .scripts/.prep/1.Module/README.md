# Module :one: Introduction to AD DS Domain Controllers


Des **exemples PowerShell** concrets pour illustrer chacun des **5 modules** (installation, maintenance, rôles FSMO, RODC, etc.) liés à **Active Directory Domain Services (AD DS)**.

Voici une **synthèse structurée**, parfaitement adaptée à un TP ou à une présentation de 30 à 45 minutes 💡

---

## 🧩 1️⃣ Active Directory Domain Services overview (6 min)

### 💡 Objectif :

Découvrir les principaux cmdlets PowerShell AD DS.

### 🔍 Exemples PowerShell :

```powershell
# Lister les modules disponibles pour AD
Get-Module -ListAvailable | Where-Object { $_.Name -like "*AD*" }

# Importer le module Active Directory
Import-Module ActiveDirectory

# Vérifier si le service AD DS est installé
Get-WindowsFeature AD-Domain-Services

# Lister les utilisateurs et ordinateurs du domaine
Get-ADUser -Filter * | Select-Object Name, SamAccountName
Get-ADComputer -Filter * | Select-Object Name, Enabled
```

---

## 🧩 2️⃣ Deploying AD DS domain controllers (5 min)

### 💡 Objectif :

Installer le rôle AD DS et promouvoir le serveur comme contrôleur de domaine (DC).

### ⚙️ Exemples PowerShell :

#### ➤ Installation du rôle :

```powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```

#### ➤ Créer une **nouvelle forêt** :

```powershell
Install-ADDSForest `
  -DomainName "lab.local" `
  -DomainNetbiosName "LAB" `
  -SafeModeAdministratorPassword (ConvertTo-SecureString "MotDePasseDSRM123!" -AsPlainText -Force) `
  -InstallDNS:$true `
  -Force
```

#### ➤ Ajouter un **DC secondaire** à un domaine existant :

```powershell
Install-ADDSDomainController `
  -DomainName "lab.local" `
  -Credential (Get-Credential) `
  -InstallDNS:$true `
  -SafeModeAdministratorPassword (ConvertTo-SecureString "MotDePasseDSRM123!" -AsPlainText -Force) `
  -Force
```

---

## 🧩 3️⃣ Maintaining AD DS domain controllers (5 min)

### 💡 Objectif :

Surveiller et maintenir la santé des DC.

### ⚙️ Exemples PowerShell :

```powershell
# Vérifier la santé du domaine
dcdiag

# Vérifier la réplication entre DCs
repadmin /replsummary

# Forcer la réplication manuelle
repadmin /syncall /AdeP

# Sauvegarder la configuration du domaine (snapshot)
ntdsutil "snapshot" "create" "quit" "quit"

# Vérifier les services AD
Get-Service | Where-Object { $_.DisplayName -like "*Directory*" -or $_.DisplayName -like "*DNS*" }
```

---

## 🧩 4️⃣ Setting up Read-Only Domain Controllers (RODC) (5 min)

### 💡 Objectif :

Créer un DC en lecture seule pour la sécurité et la performance (souvent dans des succursales).

### ⚙️ Exemples PowerShell :

```powershell
# Ajouter un RODC à un domaine existant
Install-ADDSDomainController `
  -DomainName "lab.local" `
  -ReadOnlyReplica:$true `
  -Credential (Get-Credential) `
  -InstallDNS:$true `
  -SafeModeAdministratorPassword (ConvertTo-SecureString "MotDePasseDSRM123!" -AsPlainText -Force) `
  -Force

# Vérifier les RODC existants
Get-ADDomainController -Filter { IsReadOnly -eq $true } | Select-Object Name, Site
```

---

## 🧩 5️⃣ Managing AD DS Operations Masters (FSMO roles) (6 min)

### 💡 Objectif :

Gérer les **rôles FSMO (Flexible Single Master Operations)** :

* **Schema Master**
* **Domain Naming Master**
* **RID Master**
* **PDC Emulator**
* **Infrastructure Master**

### ⚙️ Exemples PowerShell :

```powershell
# Afficher les rôles FSMO actuels
Get-ADDomain | Select-Object RIDMaster, InfrastructureMaster, PDCEmulator
Get-ADForest | Select-Object SchemaMaster, DomainNamingMaster

# Transférer un rôle FSMO
Move-ADDirectoryServerOperationMasterRole -Identity "DC02" -OperationMasterRole SchemaMaster

# Vérifier le DC actuel
Get-ADDomainController -Discover -Service "PrimaryDC"

# Tester la connectivité et le rôle
nltest /dsgetdc:lab.local
```

---

## 🧾 Résumé synthèse

| Module       | Action principale                        | Cmdlet clé                                           |
| ------------ | ---------------------------------------- | ---------------------------------------------------- |
| 1️⃣ Overview | Découverte et inspection                 | `Get-ADUser`, `Get-ADComputer`                       |
| 2️⃣ Deploy   | Installation et promotion DC             | `Install-ADDSForest`, `Install-ADDSDomainController` |
| 3️⃣ Maintain | Surveillance et réplication              | `dcdiag`, `repadmin`, `Get-Service`                  |
| 4️⃣ RODC     | Création de contrôleurs en lecture seule | `Install-ADDSDomainController -ReadOnlyReplica`      |
| 5️⃣ FSMO     | Gestion des rôles maîtres                | `Move-ADDirectoryServerOperationMasterRole`          |

---



```powershell
$strRemoteForest = "DC300098957.DC300098957-40.local" 
$strRemoteAdmin = "Administrator" 
$strRemoteAdminPassword = "Infra@2024" 
$remoteContext = New-Object `
    -TypeName"System.DirectoryServices.ActiveDirectory.DirectoryContext" `
    -ArgumentList @( "Forest",$strRemoteForest, $strRemoteAdmin, $strRemoteAdminPassword) 
```


```powershell
# Change following parameters 
$strRemoteForest = "forestName1.something" 

$strRemoteAdmin = "adminAccountName" 

$strRemoteAdminPassword = "Heslo@123" 

$remoteContext = New-Object -TypeName"System.DirectoryServices.ActiveDirectory.DirectoryContext" -ArgumentList @( "Forest",$strRemoteForest, $strRemoteAdmin, $strRemoteAdminPassword) 

try { 

$remoteForest =[System.DirectoryServices.ActiveDirectory.Forest]::getForest($remoteContext) 

#Write-Host "GetRemoteForest: Succeeded for domain $($remoteForest)" 

} 

catch { 

Write-Warning "GetRemoteForest: Failed:`n`tError: $($($_.Exception).Message)" 

} 

Write-Host "Connected to Remote forest: $($remoteForest.Name)" 

$localforest=[System.DirectoryServices.ActiveDirectory.Forest]::getCurrentForest() 

Write-Host "Connected to Local forest: $($localforest.Name)" 

try { 

$localForest.CreateTrustRelationship($remoteForest,"Inbound") 

Write-Host "CreateTrustRelationship: Succeeded for domain $($remoteForest)" 

} 

catch { 

Write-Warning "CreateTrustRelationship: Failed for domain$($remoteForest)`n`tError: $($($_.Exception).Message)" 

}
```

---


Super — voilà un **script PowerShell “tout-en-un”** qui utilise **Carbon / ActiveDirectory** pour la préparation (OU / groupe) et **netdom** pour créer et vérifier un trust entre deux domaines.
Le script est interactif : il te demandera les identifiants admin pour **le domaine source** et **le domaine cible**, ainsi qu’un mot de passe partagé pour le trust. Il vérifie aussi des prérequis (résolution DNS, présence de netdom, connectivité, synchronisation horaire basique) et fait du logging simple.

> ⚠️ **Important sécurité** : `netdom` demande les mots de passe en clair sur la ligne de commande. Le script récupère les mots de passe depuis des `PSCredential` et les passe à `netdom` (ils apparaîtront temporairement en clair dans la ligne de commande / mémoire). Exécute-le dans un contexte sûr et supprime les éléments temporaires si besoin.

Copie/colle tout le bloc suivant dans un fichier `Create-ADTrust-Carbon-Netdom.ps1` et exécute-le en tant qu’Administrateur sur une machine qui peut joindre les deux domaines.

```powershell
<#
.SYNOPSIS
  Prépare OU/groupe et crée un trust AD entre deux domaines avec Carbon/ActiveDirectory + netdom.

.NOTES
  - Exécuter en tant qu'administrateur.
  - Nécessite : netdom (fourni par RSAT / Windows Server).
  - Fournir des identifiants admin pour chaque domaine lorsqu'on le demande.
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$SourceDomain,    # ex: source.local (domaine qui initie le trust)
    [Parameter(Mandatory=$true)]
    [string]$TargetDomain,    # ex: target.local (domaine à faire confiance)
    [ValidateSet("External","Forest")]
    [string]$TrustType = "External",
    [ValidateSet("TwoWay","OneWay")]
    [string]$Direction = "TwoWay", # simplifié (TwoWay ou OneWay)
    [switch]$CreatePrepObjects  # si set, création d'une OU + groupe dans chaque domaine
)

function Log { param($m) Write-Host "[`$(Get-Date -Format u)`] $m" }

# ---------- Prérequis ----------
Log "Vérification prérequis..."
if (-not (Get-Command netdom -ErrorAction SilentlyContinue)) {
    Write-Error "netdom introuvable dans le PATH. Installe RSAT ou utilise un DC avec netdom."
    exit 1
}

# Résolution DNS
function Test-DnsResolve {
    param($name)
    try {
        Resolve-DnsName -Name $name -ErrorAction Stop | Out-Null
        return $true
    } catch {
        return $false
    }
}

if (-not (Test-DnsResolve $SourceDomain)) {
    Write-Warning "Résolution DNS du domaine source '$SourceDomain' échouée. Vérifie DNS/connexion."
}
if (-not (Test-DnsResolve $TargetDomain)) {
    Write-Warning "Résolution DNS du domaine cible '$TargetDomain' échouée. Vérifie DNS/connexion."
}

# Test ping (ICMP)
if (-not (Test-Connection -ComputerName $SourceDomain -Count 1 -Quiet)) {
    Write-Warning "Ping vers $SourceDomain a échoué (ICMP)."
}
if (-not (Test-Connection -ComputerName $TargetDomain -Count 1 -Quiet)) {
    Write-Warning "Ping vers $TargetDomain a échoué (ICMP)."
}

# ---------- Import modules utiles ----------
# Import ActiveDirectory if available (pour création d'OU/groupe)
try {
    Import-Module ActiveDirectory -ErrorAction Stop
    $hasADModule = $true
    Log "Module ActiveDirectory importé."
} catch {
    $hasADModule = $false
    Write-Warning "Module ActiveDirectory non disponible sur cette machine. Certaines préparations seront sautées."
}

# Import Carbon if present (optionnel)
try {
    Import-Module Carbon -ErrorAction Stop
    $hasCarbon = $true
    Log "Module Carbon importé."
} catch {
    $hasCarbon = $false
    Log "Carbon non installé ou non trouvé (optionnel)."
}

# ---------- Demandes d'identifiants ----------
Write-Host ""
Log "Saisir les identifiants administrateur du domaine SOURCE ($SourceDomain)."
$credSource = Get-Credential -Message "Admin $SourceDomain (format: DOMAIN\user or user@domain)"

Write-Host ""
Log "Saisir les identifiants administrateur du domaine TARGET ($TargetDomain)."
$credTarget = Get-Credential -Message "Admin $TargetDomain (format: DOMAIN\user or user@domain)"

# Trust password partagé (sera passé à netdom)
Write-Host ""
$plainTrustPassword = Read-Host "Mot de passe partagé pour le trust (sera utilisé par netdom)" -AsSecureString
# Convert SecureString -> plaintext (nécessaire pour netdom)
$ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($plainTrustPassword)
$trustPassword = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
[Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)  # libérer

# ---------- Préparation (optionnelle) ----------
if ($CreatePrepObjects) {
    if (-not $hasADModule) {
        Write-Warning "Impossible de créer OU/groupe car module ActiveDirectory absent."
    } else {
        Log "Création d'une OU et d'un groupe 'TrustAdmins' dans chaque domaine (si absent)."
        # Source domain OU/group
        try {
            $sourceDN = "OU=TrustPrep,DC=" + ($SourceDomain -split '\.') -join ",DC="
            if (-not (Get-ADOrganizationalUnit -Filter "Name -eq 'TrustPrep'" -Server $SourceDomain -ErrorAction SilentlyContinue)) {
                New-ADOrganizationalUnit -Name "TrustPrep" -Path ("DC=" + ($SourceDomain -split '\.') -join ",DC=") -Server $SourceDomain
                Log "OU TrustPrep créée dans $SourceDomain"
            }
            if (-not (Get-ADGroup -Filter "Name -eq 'TrustAdmins'" -Server $SourceDomain -ErrorAction SilentlyContinue)) {
                New-ADGroup -Name "TrustAdmins" -GroupScope Global -Path $sourceDN -Server $SourceDomain -ErrorAction Stop
                Log "Groupe TrustAdmins créé dans $SourceDomain"
            }
        } catch {
            Write-Warning "Erreur préparation $SourceDomain : $_"
        }

        # Target domain OU/group
        try {
            $targetDN = "OU=TrustPrep,DC=" + ($TargetDomain -split '\.') -join ",DC="
            if (-not (Get-ADOrganizationalUnit -Filter "Name -eq 'TrustPrep'" -Server $TargetDomain -ErrorAction SilentlyContinue)) {
                New-ADOrganizationalUnit -Name "TrustPrep" -Path ("DC=" + ($TargetDomain -split '\.') -join ",DC=") -Server $TargetDomain
                Log "OU TrustPrep créée dans $TargetDomain"
            }
            if (-not (Get-ADGroup -Filter "Name -eq 'TrustAdmins'" -Server $TargetDomain -ErrorAction SilentlyContinue)) {
                New-ADGroup -Name "TrustAdmins" -GroupScope Global -Path $targetDN -Server $TargetDomain -ErrorAction Stop
                Log "Groupe TrustAdmins créé dans $TargetDomain"
            }
        } catch {
            Write-Warning "Erreur préparation $TargetDomain : $_"
        }
    }
}

# ---------- Construction de la ligne de commande netdom ----------
# netdom syntax (exemples):
# netdom trust <TrustingDomain> /domain:<TrustedDomain> /UserO:<user> /PasswordO:<pwd> /UserD:<user> /PasswordD:<pwd> /Add /TwoWay /PasswordT:<pwd>
# Ici on exécute depuis le côté "source" (TrustingDomain = $SourceDomain)

$argList = @()
$argList += "trust"
$argList += $SourceDomain
$argList += "/Domain:$TargetDomain"

# Prepare user/password args
$srcUser = $credSource.UserName
$srcPwd = $credSource.GetNetworkCredential().Password
$tgtUser = $credTarget.UserName
$tgtPwd = $credTarget.GetNetworkCredential().Password

# Add creds (UserO = account on source executing the command, UserD = account on target)
$argList += "/UserO:$srcUser"
$argList += "/PasswordO:$srcPwd"
$argList += "/UserD:$tgtUser"
$argList += "/PasswordD:$tgtPwd"

# Add operation flags
$argList += "/Add"
if ($Direction -eq "TwoWay") {
    $argList += "/TwoWay"
} else {
    $argList += "/OneWay"
}

# Trust password for the trust itself
$argList += "/PasswordT:$trustPassword"
# Optional : verify immediately
$argList += "/Verify"

$finalArgs = $argList -join " "

Log "Commande netdom construite (exécutée en clair) : netdom $finalArgs"
Log "Exécution de la commande netdom..."

# ---------- Execution ----------
$proc = Start-Process -FilePath "netdom" -ArgumentList $argList -NoNewWindow -Wait -PassThru

if ($proc.ExitCode -eq 0) {
    Log "netdom a retourné 0 : création du trust demandée avec succès (voir messages netdom)."
} else {
    Write-Error "netdom a retourné le code $($proc.ExitCode). Vérifier les messages affichés par netdom."
    exit $proc.ExitCode
}

# ---------- Vérification via netdom et Get-ADTrust (si possible) ----------
Log "Vérification du trust via netdom..."
$verifyProc = Start-Process -FilePath "netdom" -ArgumentList @("trust",$SourceDomain,"/domain:$TargetDomain","/Verify") -NoNewWindow -Wait -PassThru
if ($verifyProc.ExitCode -eq 0) {
    Log "Vérification netdom OK."
} else {
    Write-Warning "La vérification netdom a renvoyé code $($verifyProc.ExitCode)."
}

if ($hasADModule) {
    try {
        Log "Affichage Get-ADTrust depuis le côté source (si disponible)..."
        Get-ADTrust -Filter {Source -eq $SourceDomain -or Target -eq $TargetDomain} -Server $SourceDomain -ErrorAction SilentlyContinue |
            Format-Table Name, TrustType, TrustDirection, IsTransitive -AutoSize
    } catch {
        Write-Warning "Get-ADTrust non disponible ou erreur : $_"
    }
}

Log "Opération terminée."
```

---

### Explications rapides

* Le script :

  * vérifie `netdom` et DNS, importe les modules AD/Carbon si présents ;
  * demande les identifiants admin de chaque domaine (via `Get-Credential`) ;
  * optionnellement crée une OU `TrustPrep` et un groupe `TrustAdmins` dans chaque domaine (si tu passes le flag `-CreatePrepObjects`) ;
  * exécute `netdom trust ... /Add /TwoWay /PasswordT:... /Verify` pour créer et vérifier le trust ;
  * affiche un `Get-ADTrust` si le module AD est disponible côté source.

* Pour l’exécuter (exemple) :

```powershell
# en tant qu'Admin
.\Create-ADTrust-Carbon-Netdom.ps1 -SourceDomain source.local -TargetDomain target.local -TrustType External -Direction TwoWay -CreatePrepObjects
```

---

### Conseils / notes

* **Exécute depuis une machine qui peut joindre les deux domaines** (ports RPC/SMB et DNS doivent être accessibles).
* Si tu souhaites **automatiser sans interaction**, il faudra stocker les mots de passe (risqué) ou utiliser une approche basée sur comptes de service gérés/RunAs avec clefs sécurisées.
* Après création : vérifie la réplication, la visibilité dans **Active Directory Domains and Trusts** et teste l’accès inter-domaines (résolution, authentification).
---

# :books: References

- [ ] [Powershell to Create AD Trust](https://www.anujvarma.com/powershell-to-create-ad-trust)
- [ ] [Querying Active Directory With PowerShell](https://evilsaint.com/article/querying-active-directory-with-powershell.html)
- [ ] [Setting up AD Trusts](https://www.youtube.com/watch?v=Wrl8PrWv-6M)

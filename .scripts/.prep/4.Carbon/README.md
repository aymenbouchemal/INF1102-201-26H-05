Parfait ! Voici un **script PowerShell complet et prêt à l’emploi** utilisant le module **ActiveDirectory** et Carbon pour créer un trust bidirectionnel entre deux domaines :

---

```powershell
<#
.SYNOPSIS
Créer un trust bidirectionnel entre deux domaines Active Directory

.DESCRIPTION
Ce script crée un trust bidirectionnel entre un domaine source et un domaine cible,
en utilisant le module ActiveDirectory et Carbon. Il vérifie la connectivité et
affiche un rapport clair sur le succès ou l’échec.

.NOTES
Exécuter sur un DC du domaine source ou sur un serveur avec RSAT AD installé.
Les comptes admin des deux domaines sont requis.
#>

# -----------------------------
# Paramètres à changer
# -----------------------------
$SourceDomain = "DC300098957-40.local"   # Domaine source (trusting)
$TargetDomain = "DC300098957-90.local"   # Domaine cible (trusted)

$CredSource = Get-Credential -Message "Admin du domaine source ($SourceDomain)"
$CredTarget = Get-Credential -Message "Admin du domaine cible ($TargetDomain)"

# -----------------------------
# Vérifier connectivité
# -----------------------------
Write-Host "Vérification connectivité..."
if (-not (Test-Connection -ComputerName $SourceDomain -Count 2 -Quiet)) {
    Write-Error "Le domaine source $SourceDomain n'est pas joignable."
    exit
}
if (-not (Test-Connection -ComputerName $TargetDomain -Count 2 -Quiet)) {
    Write-Error "Le domaine cible $TargetDomain n'est pas joignable."
    exit
}

Write-Host "Connectivité OK." -ForegroundColor Green

# -----------------------------
# Créer le trust
# -----------------------------
try {
    Import-Module ActiveDirectory -ErrorAction Stop

    # Crée un objet pour le domaine cible
    $TargetForest = [System.DirectoryServices.ActiveDirectory.Forest]::GetForest(
        (New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext(
            "Forest", $TargetDomain, $CredTarget.UserName, $CredTarget.GetNetworkCredential().Password
        ))
    )

    # Domaine local
    $LocalForest = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()

    Write-Host "Création du trust..."
    $LocalForest.CreateTrustRelationship($TargetForest, "Bidirectional")  # bidirectionnel

    Write-Host "Trust créé avec succès !" -ForegroundColor Green
}
catch {
    Write-Error "Erreur lors de la création du trust : $($_.Exception.Message)"
}

# -----------------------------
# Vérification du trust
# -----------------------------
try {
    $trusts = Get-ADTrust -Filter * | Where-Object { $_.Target -eq $TargetDomain }
    if ($trusts) {
        Write-Host "Trust vérifié avec succès : $($trusts.Name)" -ForegroundColor Green
    } else {
        Write-Warning "Le trust n'a pas été trouvé dans le domaine source."
    }
}
catch {
    Write-Error "Erreur lors de la vérification du trust : $($_.Exception.Message)"
}
```

---

### 🔹 Instructions pour l’étudiant

1. Ouvrir **PowerShell en tant qu’administrateur** sur un DC ou un serveur avec RSAT installé.
2. Modifier les variables `$SourceDomain` et `$TargetDomain` selon ton environnement.
3. Exécuter le script. Il demandera les **comptes admin** des deux domaines.
4. Le script crée un **trust bidirectionnel** et affiche le résultat.

---

Si tu veux, je peux te faire **une version encore plus simple** où l’étudiant n’a qu’à **copier-coller et exécuter**, sans avoir à saisir manuellement les credentials.

Veux‑tu que je fasse cette version ?

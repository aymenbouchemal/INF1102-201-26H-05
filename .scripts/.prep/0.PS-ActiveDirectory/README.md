

### 🪗 [Gathering AD Data with the Active Directory PowerShell Module](https://adsecurity.org/?p=3719)

## 🎋 Naviguer dans l'arborescence d'AD

- [ ] Charger le module de commande

```powershell
import-module ActiveDirectory
```

- [ ] Afficher le `Driver` **ad:**

```powershell
ls ad:
```
<details>

```lua
Name                 ObjectClass          DistinguishedName
----                 -----------          -----------------
LABINFO              domainDNS            DC=LABINFO,DC=LOCAL
Configuration        configuration        CN=Configuration,DC=LABINFO,DC=LOCAL
Schema               dMD                  CN=Schema,CN=Configuration,DC=LABINFO,DC=LOCAL
DomainDnsZones       domainDNS            DC=DomainDnsZones,DC=LABINFO,DC=LOCAL
ForestDnsZones       domainDNS            DC=ForestDnsZones,DC=LABINFO,DC=LOCAL
```

</details>

- [ ] Se déplacer vers le `Driver`

```powershell
cd ad: # ou set-location ad: 
```

Le prompt `PowerShell` changera à 
> PS AD:\> 

```powershell
set-location "DC=LABINFO,DC=LOCAL"
PS AD:\DC=LABINFO,DC=LOCAL> set-location $HOME
PS C:\Users\300098957> get-ADDomain
```

```bash
ls ad:
```
<details>

```lua
Name                 ObjectClass          DistinguishedName
----                 -----------          -----------------
Infrastructure       infrastructureUpdate CN=Infrastructure,DC=ForestDnsZones,DC=LABINFO,DC=LOCAL
LostAndFound         lostAndFound         CN=LostAndFound,DC=ForestDnsZones,DC=LABINFO,DC=LOCAL
MicrosoftDNS         container            CN=MicrosoftDNS,DC=ForestDnsZones,DC=LABINFO,DC=LOCAL
NTDS Quotas          msDS-QuotaContainer  CN=NTDS Quotas,DC=ForestDnsZones,DC=LABINFO,DC=LOCAL
```

</details>


Pour **lister seulement `student1`**, tu as 3 méthodes simples.
Comme tu vois, `student1` apparaît déjà dans le résultat global du conteneur **CN=Users**, donc il suffit de filtrer ou cibler l'objet directement.

---

# ✅ **1. Filtrer dans le conteneur Users**

Utilise `Where-Object` :

```powershell
ls 'AD:\CN=Users,DC=DC300098957-90,DC=local' |
    Where-Object { $_.Name -eq "student1" }
```

---

# ✅ **2. Accès direct via chemin AD**

Si tu connais le DN exact (il apparaît dans ton résultat) :

```powershell
ls 'AD:\CN=student1,CN=Users,DC=DC300098957-90,DC=local'
```

---

# ✅ **3. Via le cmdlet Get-ADUser**

Méthode la plus propre :

```powershell
Get-ADUser -Identity student1 -Properties *
```

Ou seulement le résumé :

```powershell
Get-ADUser student1
```

---

# ⭐ Le DN exact de ton utilisateur

Tu peux toujours vérifier avec :

```powershell
Get-ADUser student1 -Properties DistinguishedName
```

---

# ✔️ Résumé

Pour **lister student1**, le plus simple est :

> ls ou gci # ou Get-ChildItem

```powershell
ls 'AD:\CN=student2,CN=Users,DC=DC300098957-90,DC=local'
```
<details>

```powershell
ls : Cannot find path '//RootDSE/CN=student2,CN=Users,DC=DC300098957-90,DC=local' because it does not exist.
At line:1 char:1
+ ls 'AD:\CN=student2,CN=Users,DC=DC300098957-90,DC=local'
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (//RootDSE/CN=st...957-90,DC=local:String) [Get-ChildItem], ItemNotFound
   Exception
    + FullyQualifiedErrorId : PathNotFound,Microsoft.PowerShell.Commands.GetChildItemCommand
```

</details>

ou filtrer :

```powershell
ls 'AD:\CN=Users,DC=DC300098957-90,DC=local' | where Name -eq "student1"
```

>
<details>

```powershell
Name                 ObjectClass          DistinguishedName
----                 -----------          -----------------
student1             user                 CN=student1,CN=Users,DC=DC300098957-90,DC=local
```

</details>


# :books: References

- [ ] [MASTERING ACTIVE DIRECTORY
WITH POWERSHELL](https://adsecurity.org/wp-content/uploads/2015/04/NoVaPowerShellUsersGroup2015-ActiveDirectoryPowerShell.pdf)
- [ ] [How to Install and Import Active Directory PowerShell Module](https://www.varonis.com/blog/powershell-active-directory-module)

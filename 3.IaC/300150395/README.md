\# Travail IaC



VM Proxmox créée avec OpenTofu pour le cours INF1102.



---



\## 1. Commandes utilisées 



```powershell

tofu init

tofu plan

tofu apply

```

\## 2. Résumé de l’état OpenTofu

```powershell



json

{

&nbsp; "type": "proxmox\_vm\_qemu",

&nbsp; "name": "vm300150395",

&nbsp; "ipconfig0": "ip=10.7.237.233/23,gw=10.7.237.1"

}

```

Cet extrait JSON montre que la VM vm300150395 a bien été créée sur Proxmox avec l’adresse IP 10.7.237.233/23 et la passerelle 10.7.237.1.







\## 3. Capture d’écran de la VM



\## Capture d’écran de ma VM vm300150395



Cette image est la capture de l’accès à ma machine virtuelle vm300150395 créée automatiquement avec OpenTofu sur Proxmox.



!\[Capture d’écran de ma VM vm300150395](/images/1.png)





\## 3. Contenu de tfvars



```PowerShell



pm\_vm\_name      = "vm300150395"                                                                                      pm\_ipconfig0    = "ip=10.7.237.233/23,gw=10.7.237.1"                                                                 pm\_nameserver   = "10.7.237.3"                                                                                       pm\_url          = "https://10.7.236.19:8006/api2/json"                                                               pm\_token\_id     = "tofu@pve!opentofu"                                                                                pm\_token\_secret = "f2097a3c-f9f0-4558-9a43-5cd0ae718abe" 



```   




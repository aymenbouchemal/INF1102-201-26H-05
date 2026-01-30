# Nouveau fichier students.ps1
# Liste des étudiants A25 avec IDS et AVATARS correspondants

$STUDENTS = @(
"300135538|RedaYousfi|133056385"
"300141570|octocat|583231"
"300146112|laggabkhalef|205994703"
"300146676|harkatiaymen|211595997"
"300148094|ouailg28|212054634"
"300150268|kemiche06|207268490"
"300150275|octocat|583231"
"300150296|bnnyouba99|205198510"
"300150395|ismailtrache|211577767"
"300150557|hanichou|205994729"
"300151233|syphax25|223416913"
"300151258|hakimsb|231778604"
"300151347|sarahocine|207281891"
"300151403|JustinSandy99|211593057"
"300151466|octocat|583231"
"300151556|Kahinazerkani|231781132"
"300151608|mohammedaiche434|205994734"
"300152131|el-calvino|205994709"
"300152260|bekkai-mohibb|212179557"
"300152410|imadboudeuf|205994834"
)

# --------------------------------------
# Division des étudiants en 2 groupes
# --------------------------------------

$TOTAL = $STUDENTS.Count
$GROUP_SIZE = [Math]::Ceiling($TOTAL / 2)

$GROUP_1 = $STUDENTS[0..($GROUP_SIZE - 1)]
$GROUP_2 = $STUDENTS[($GROUP_SIZE)..($TOTAL - 1)]

# --------------------------------------
# Division des VMs en 2 groupes
# --------------------------------------

$SERVERS = @(
"10.7.237.224"
"10.7.237.226"
"10.7.237.227"
"10.7.237.228"
"10.7.237.229"
"10.7.237.230"
"10.7.237.231"
"10.7.237.232"
"10.7.237.233"
"10.7.237.234"
"10.7.237.235"
"10.7.237.236"
"10.7.237.237"
"10.7.237.238"
"10.7.237.239"
"10.7.237.240"
"10.7.237.241"
"10.7.237.242"
"10.7.237.243"
"10.7.237.245"
)

$SERVER_GROUP_1 = $SERVERS[0..($GROUP_SIZE - 1)]
$SERVER_GROUP_2 = $SERVERS[($GROUP_SIZE)..($TOTAL - 1)]

# --------------------------------------
# S21	https://10.7.236.19:8006	64	16	272	Virtual Environment 7.4-20
# S25	https://10.7.237.38:8006	64	16	272	Virtual Environment 7.4-20
# --------------------------------------

$PROXMOX_SERVERS = @(
"10.7.236.19"
"10.7.237.38"
)

$PROXMOX_GROUP_1 = $PROXMOX_SERVERS[0] 
$PROXMOX_GROUP_2 = $PROXMOX_SERVERS[1] 

# --------------------------------------
# pm_token_id     = "tofu@pve!opentofu"
# pm_token_secret = "4fa24fc3-bd8c-4916-ba6e-09xxxxxx3b00"
# --------------------------------------

$TOFU_SECRETS = @(
"f2097a3c-f9f0-4558-9a43-5cd0ae718abe"
"1cde2cfc-e100-47b9-9ee2-591ed83cfb8e"
)

$TOFU_SECRET_GROUP_1 = $TOFU_SECRETS[0] 
$TOFU_SECRET_GROUP_2 = $TOFU_SECRETS[1] 

Infrastructure as Code : Déploiement Azure avec Terraform & GitHub Actions

Ce projet automatise le déploiement d'une infrastructure complète sur Azure (Réseau, Sécurité, Machine Virtuelle) en utilisant Terraform et un pipeline CI/CD robuste.

🚀 Architecture Déployée

Resource Group : Conteneur logique pour toutes les ressources.
VNet & Subnet : Réseau virtuel isolé pour la communication.
Network Security Group (NSG) : Règles de pare-feu pour autoriser le SSH.
Linux VM : Instance Ubuntu configurée avec une clé SSH sécurisée.
Remote Backend : État Terraform stocké sur Azure Blob Storage avec verrouillage (lease).

🛠️ PrérequisUn compte Azure avec une souscription active.Un dépôt GitHub.
Une paire de clés SSH (Générée via ssh-keygen -t rsa -b 4096).

1️⃣ Préparation du Backend Azure

Terraform doit stocker son fichier d'état (.tfstate) sur Azure pour permettre le travail collaboratif.

Créez un Storage Account et un Blob Container (nommé tfstate).

Notez les informations suivantes pour le fichier main.tf du backend :resource_group_namestorage_account_namecontainer_namekey (ex: dev.terraform.tfstate)

2️⃣ Configuration des Secrets GitHubPour que GitHub puisse agir sur Azure, ajoutez les secrets suivants dans Settings > Environments > dev :Nom du SecretDescriptionAZURE_CLIENT_IDID de l'application (Service Principal)AZURE_CLIENT_SECRETMot de passe de l'applicationAZURE_SUBSCRIPTION_IDID de votre abonnement AzureAZURE_TENANT_IDID de votre locataire AzureSSH_PUBLIC_KEYLe contenu de votre clé id_rsa.pub

3️⃣ Structure du Code TerraformAssurez-vous que votre module compute utilise une taille de VM disponible.

Note : Si Standard_B1s est indisponible (Erreur 409), utilisez Standard_B1ms ou Standard_B2s.

Terraform # modules/compute/main.tf

resource "azurerm_linux_virtual_machine" "vm_azure" {
  name                = "vm-dev-01"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B1ms" # Taille recommandée pour éviter les quotas
  admin_username      = "adminuser"
  # ... configuration network_interface_ids ...
  admin_ssh_key {
    username   = "adminuser"
    public_key = var.ssh_public_key
  }
}

4️⃣ Utilisation du Pipeline CI/CDLe workflow se trouve dans .github/workflows/terraform-dev.yml.
Actions AutomatiquesPush sur dev : Déclenche un Terraform Plan pour prévisualiser les changements.
Merge sur main : Déclenche le Terraform Apply qui déploie réellement l'infrastructure sur Azure.
Actions ManuellesDestroy : Allez dans l'onglet Actions, sélectionnez le workflow, et cliquez sur Run workflow pour tout supprimer proprement.

5️⃣ Résolution des Problèmes CourantsErreur : "State blob is already locked"

Si un job est interrompu, Azure garde un "bail" (lease) sur le fichier d'état.
Allez sur le portail Azure.Trouvez le fichier .tfstate dans votre Blob Storage.
Cliquez sur Break Lease (Casser le bail).Erreur : "SkuNotAvailable"
Cela signifie que la taille de la VM choisie n'est plus disponible dans la zone eastus.
Solution : Modifiez la variable size dans votre code Terraform pour une instance différente (ex: Standard_B1ms).

6️⃣ Accès à la VMUne fois le déploiement réussi (Apply), récupérez l'IP publique dans les logs GitHub Actions ou sur le portail Azure

Puis connectez-vous :Bashssh -i ~/.ssh/id_rsa adminuser@<IP_PUBLIQUE_VM>

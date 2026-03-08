# 1. Définition des variables (Modifiez 'NOM_UNIQUE' par votre nom/pseudo)
RESOURCE_GROUP_NAME="rg-terraform-mgmt"
LOCATION="westeurope"
STORAGE_ACCOUNT_NAME="tfstate$(date +%s)" # Génère un nom comme tfstate1710000000
CONTAINER_NAME="tfstate"

# 2. Création du Groupe de Ressources
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# 3. Création du Compte de Stockage (Standard LRS pour le Free Tier)
az storage account create \
  --name $STORAGE_ACCOUNT_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --location $LOCATION \
  --sku Standard_LRS \
  --kind StorageV2 \
  --allow-blob-public-access false

# 4. Création du Conteneur de Blob pour le fichier .tfstate
az storage container create \
  --name $CONTAINER_NAME \
  --account-name $STORAGE_ACCOUNT_NAME
  
# 5. Affichage des informations pour votre fichier Terraform
echo "--------------------------------------------------------"
echo "Recopiez ces valeurs dans votre bloc backend Terraform :"
echo "resource_group_name  = \"$RESOURCE_GROUP_NAME\""
echo "storage_account_name = \"$STORAGE_ACCOUNT_NAME\""
echo "container_name       = \"$CONTAINER_NAME\""
echo "--------------------------------------------------------"
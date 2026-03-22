# Infrastructure as Code: Azure Deployment with Terraform & GitHub Actions

This project automates the deployment of a complete infrastructure on Azure (Networking, Security, and Virtual Machines) using Terraform and a robust CI/CD pipeline.

## 🚀 Deployed Architecture
* **Resource Group**: A logical container for all infrastructure resources.
* **VNet & Subnet**: An isolated virtual network for secure communication.
* **Network Security Group (NSG)**: Firewall rules configured to allow SSH access.
* **Linux VM**: An Ubuntu instance configured with a secure SSH public key.
* **Remote Backend**: Terraform state stored in Azure Blob Storage with lease locking to prevent concurrent execution conflicts.



---

## 🛠️ Prerequisites
* An **Azure Account** with an active subscription.
* A **GitHub Repository**.
* An **SSH Key Pair** (Generated via `ssh-keygen -t rsa -b 4096`).

---

## 1️⃣ Azure Backend Preparation
Terraform must store its state file (`.tfstate`) on Azure to enable collaborative work and state persistence.

1. Create a **Storage Account** and a **Blob Container** (named `tfstate`).
2. Note the following information for your backend configuration:
   * `resource_group_name`
   * `storage_account_name`
   * `container_name`
   * `key` (e.g., `dev.terraform.tfstate`)

---

## 2️⃣ GitHub Secrets Configuration
To allow GitHub Actions to authenticate with Azure, add the following secrets in **Settings > Environments > dev**:

| Secret Name | Description |
| :--- | :--- |
| `AZURE_CLIENT_ID` | Application (Service Principal) ID |
| `AZURE_CLIENT_SECRET` | Application Password/Secret |
| `AZURE_SUBSCRIPTION_ID` | Your Azure Subscription ID |
| `AZURE_TENANT_ID` | Your Azure Tenant ID |
| `SSH_PUBLIC_KEY` | The content of your `id_rsa.pub` key |

---

## 3️⃣ Terraform Code Structure
Ensure your `compute` module uses an available VM size.

> **Note**: If `Standard_B1s` is unavailable (Error 409), use `Standard_B1ms` or `Standard_B2s` to avoid capacity restrictions.

```hcl
# modules/compute/main.tf

resource "azurerm_linux_virtual_machine" "vm_azure" {
  name                = "vm-dev-01"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B1ms" # Recommended size to avoid quota issues
  admin_username      = "adminuser"
  
  # ... network_interface_ids configuration ...

  admin_ssh_key {
    username   = "adminuser"
    public_key = var.ssh_public_key
  }
}

4️⃣ CI/CD Pipeline Usage
The workflow is defined in .github/workflows/terraform-dev.yml.

Automatic Actions
Push to dev branch: Triggers a Terraform Plan to preview infrastructure changes.

Merge to main branch: Triggers the Terraform Apply which performs the actual deployment to Azure.

Manual Actions
Destroy: Navigate to the Actions tab, select the workflow, and click Run workflow to safely tear down all resources.

5️⃣ Common Troubleshooting
Error: "State blob is already locked"
If a job is interrupted, Azure may maintain a "lease" on the state file.

Go to the Azure Portal.

Locate the .tfstate file in your Blob Storage.

Click Break Lease.

Error: "SkuNotAvailable" (Status 409)
This means the chosen VM size is currently unavailable in the eastus region due to capacity restrictions.

Solution: Update the size variable in your Terraform code to a different instance type (e.g., Standard_B1ms).

6️⃣ Accessing the VM
Once the deployment succeeds (Apply), retrieve the Public IP address from the GitHub Actions logs or the Azure Portal.

Connect via SSH:

Bash
ssh -i ~/.ssh/id_rsa adminuser@<VM_PUBLIC_IP>
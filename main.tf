
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_poc_cp" {
  name     = "rg-poc-cp"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "aks-cluster"
  location            = azurerm_resource_group.rg_poc_cp.location
  resource_group_name = azurerm_resource_group.rg_poc_cp.name
  dns_prefix          = "aks"

  default_node_pool {
    name       = "system"
    node_count = 3
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "user_node_pool" {
  name                  = "user"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  vm_size               = "Standard_B2s"
  node_count            = 2
  mode                  = "User"
}


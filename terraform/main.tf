terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.0.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "12c902a2-a540-4ef3-a010-55e68f41de96"
}

resource "azurerm_resource_group" "aula_rg" {
  name = "aula-rg"
  location = "Brazil South"
}

resource "azurerm_kubernetes_cluster" "aula_k8s" {
  name                = var.k8s_name
  location            = azurerm_resource_group.aula_rg.location
  resource_group_name = azurerm_resource_group.aula_rg.name
  dns_prefix          = "aulak8s"

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

}

resource "local_file" "k8s_config" {
  content  = azurerm_kubernetes_cluster.aula_k8s.kube_config_raw
  filename = "kube_config_aks.yaml"
}

variable "k8s_name" {
  description = "Nome do cluster kubernetes"
  type = string
  default = "aula-k8s"
}

variable "node_count" {
  description = "Quantidade de nodes"
  type = number
  default = 2
}
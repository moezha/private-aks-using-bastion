resource "azurerm_kubernetes_cluster" "aks" {
  name                    = "aks-cluster"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  dns_prefix              = "aks"
  kubernetes_version      = "1.34.6"
  private_cluster_enabled = true

  network_profile {
    network_plugin      = "azure" 
    network_plugin_mode = "overlay"
    network_data_plane  = "cilium"       
    network_policy      = "cilium"       
    outbound_type       = "loadBalancer" 
    load_balancer_sku   = "standard"     
  }

  default_node_pool {
    name            = "agentpool"        
    node_count      = var.aks_node_count
    vm_size         = "Standard_D2s_v3"  
    os_sku          = "Ubuntu"           
    os_disk_size_gb = 128                
    os_disk_type    = "Managed"          
    max_pods        = 30                 
    scale_down_mode = "Delete"
    vnet_subnet_id  = azurerm_subnet.snet-aks.id
  }

  identity {
    type = "SystemAssigned"
  }

  web_app_routing {
    dns_zone_ids = []
  }

  lifecycle {
    ignore_changes = [
      default_node_pool.0.upgrade_settings
    ]
  }
}
variable "prefix" {
  type    = string
  default = "moez"
}

variable "location" {
  type        = string
  default     = "spaincentral"
  description = "The Azure region to deploy resources"
}

variable "admin_username" {
  type        = string
  default     = "moezuser"
  description = "The admin username for the Jumpbox VM"
}

variable "aks_node_count" {
  type        = number
  default     = 1
  description = "The number of nodes in the AKS default node pool"
}
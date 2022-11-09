variable "hvn_id" {
  description = "The ID of the HCP HVN"
  type        = string
}

variable "hvn_peering_id" {
  description = "The Peering ID of the HCP Vault HVN."
  type        = string
  default     = "hcp-hvn-peer"
}

variable "vpc_owner_id" {
  description = "Peer account ID from AWS for the VPC that HCP will use. Only required if HCP is peering with a VPC that has a different owner than vpc_owner_id"
  type        = string
  default     = ""
}

variable "vpc_peering" {
  description = "Flag to enable vpc peering with HCP and AWS"
  type        = bool
  default     = false
}

variable "transit_gateway" {
  description = "Flag to use an AWS transit gateway"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "Peer ID from the AWS peering VPC"
  type        = string
  default     = ""
}

variable "vpc_region" {
  description = "Region where the AWS VPC was created"
  type        = string
  default     = ""
}

variable "region" {
  description = "The region of the HCP HVN / Cluster."
  type        = string
  default     = ""
  validation {
    condition     = var.region != "us-west-2" || var.region != "us-east-1" || var.region != "eu-west-1" || var.region != "eu-west-2" || var.region != "eu-central-1" || var.region != "ap-southeast-1" || var.region != "ap-southeast-2"
    error_message = "The variable region must be \"us-west-2\", \"us-east-1\", \"eu-west-1\", \"eu-west-2\", \"eu-central-1\", \"ap-southeast-1\", or \"ap-southeast-2\"."
  }
}

variable "transit_gw_attachment_id" {
  description = "Name of the transit gateway attachment for collapsed network in HVN"
  type        = string
  default     = "hcp-hvn-transit-gw"
}

variable "transit_gw_id" {
  description = "ID of the transit gateway that exists in AWS that HCP will attach to"
  type        = string
  default     = ""
}

variable "resource_share_arn" {
  description = "Amazon Resource Name of the Resource Share that is needed to grant HCP acces to the transit gateway"
  type        = string
  default     = ""
}

variable "routes" {
  description = <<EOT
  "Routes that will be created between HCP and AWS. The ID of the route should be used as the key and the subnet should be used as the value
  {
    "bastion" = "10.0.1.0/24"
    "gcp"     = "172.200.0.0/16"
  }
  EOT
  type        = map(string)
}

variable "route_table_ids" {
  description = "(Optional) List of the route table IDs in the AWS VPC"
  type        = list(string)
  default     = [""]
}

variable "hvn_cidr_block" {
  description = "(Required) CIDR block for the HVN VPC"
  type        = string
}

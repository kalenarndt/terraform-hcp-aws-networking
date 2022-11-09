output "hvn" {
  value       = data.hcp_hvn.hvn
  description = "Output of the data block from the HCP HVN lookup"
}
######################################        VPC        #######################################

output "vpc_routes" {
  value       = var.vpc_peering ? aws_route.aws_vpc_to_hvn : null
  description = "Output map of the VPC routes from that have been created in AWS."
}

output "vpc_hvn_routes" {
  value       = var.vpc_peering ? hcp_hvn_route.vpc_route : null
  description = "Output map of the VPC routes that have been created on the HCP HVN."
}

######################################  Transit Gateway  #######################################

output "tgw_hvn_routes" {
  value       = var.transit_gateway ? hcp_hvn_route.hvn_tgw_route : null
  description = "Output map of the HVN routes that are created in HCP for the Transit Gateway"
}

output "tgw_attachment" {
  value       = var.transit_gateway ? hcp_aws_transit_gateway_attachment.tgw : null
  description = "Output map of the TGW attachment that are created."
}

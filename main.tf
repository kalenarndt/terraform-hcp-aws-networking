locals {
  vpc_route_table_ids = { for k, v in var.route_table_ids : k => v if var.vpc_peering == true }
  vpc_routes          = { for k, v in var.routes : k => v if var.vpc_peering == true }
  tgw_routes          = { for k, v in var.routes : k => v if var.transit_gateway == true }
}

// Lookup the existing HVN
data "hcp_hvn" "hvn" {
  hvn_id = var.hvn_id
}

#####################################  HVN VPC Peering ######################################

// creates a route for HVN to aws via the vpc
resource "hcp_hvn_route" "vpc_route" {
  for_each         = local.vpc_routes
  hvn_link         = data.hcp_hvn.hvn.self_link
  hvn_route_id     = each.key
  destination_cidr = each.value
  target_link      = hcp_aws_network_peering.vpc_peer[0].self_link
}

// creates a peering request with aws
resource "hcp_aws_network_peering" "vpc_peer" {
  count           = var.vpc_peering ? 1 : 0
  hvn_id          = data.hcp_hvn.hvn.hvn_id
  peering_id      = var.hvn_peering_id
  peer_vpc_id     = var.vpc_id
  peer_account_id = var.vpc_owner_id
  peer_vpc_region = var.vpc_region != "" ? var.vpc_region : var.region
}

// accept the peering request between hvn and aws
resource "aws_vpc_peering_connection_accepter" "hvn_aws_vpc_accept" {
  count                     = var.vpc_peering ? 1 : 0
  vpc_peering_connection_id = hcp_aws_network_peering.vpc_peer[0].provider_peering_id
  auto_accept               = true
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
  tags = {
    Name = var.hvn_peering_id
  }
}

// accept the peering request between hvn and aws
resource "aws_route" "aws_vpc_to_hvn" {
  for_each                  = local.vpc_route_table_ids
  route_table_id            = each.value
  destination_cidr_block    = var.hvn_cidr_block
  vpc_peering_connection_id = hcp_aws_network_peering.vpc_peer[0].provider_peering_id
}
###################################### END HVN VPC Peering ######################################

######################################  HVN Transit Gateway  #######################################


// associates the hcp provider id with the resource_share arn in aws
resource "aws_ram_principal_association" "hcp_aws_ram" {
  count              = var.transit_gateway ? 1 : 0
  resource_share_arn = var.resource_share_arn
  principal          = data.hcp_hvn.hvn.provider_account_id
}

// creates an attachment to the aws transit gateway from hvn
resource "hcp_aws_transit_gateway_attachment" "tgw" {
  count                         = var.transit_gateway ? 1 : 0
  hvn_id                        = data.hcp_hvn.hvn.hvn_id
  transit_gateway_attachment_id = var.transit_gw_attachment_id
  transit_gateway_id            = var.transit_gw_id
  resource_share_arn            = var.resource_share_arn
  lifecycle {
    # Check that variables aren't using the default value since they are required when var.transit_gateway == true
    precondition {
      condition     = var.resource_share_arn != "" || var.transit_gw_attachment_id != "" || var.transit_gw_id != ""
      error_message = "var.resource_share_arn, var.transit_gw_attachment_id, and var.transit_gw_id must have a definition when creating a transit gateway attachment."
    }
  }
}

// accept the hvn attachment to the transit gateway
resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "hvn_aws_tgw_accept" {
  count                         = var.transit_gateway ? 1 : 0
  transit_gateway_attachment_id = hcp_aws_transit_gateway_attachment.tgw[0].provider_transit_gateway_attachment_id
}

// creates a route from hvn to aws via the transit gateway
resource "hcp_hvn_route" "hvn_tgw_route" {
  for_each         = local.tgw_routes
  hvn_link         = data.hcp_hvn.hvn.self_link
  hvn_route_id     = each.key
  destination_cidr = each.value
  target_link      = hcp_aws_transit_gateway_attachment.tgw[0].self_link
}

###################################### END HVN Transit Gateway #####################################


// Lookup the existing HVN
data "hcp_hvn" "hvn" {
  hvn_id = var.hvn_id
}

##################################### Single HVN VPC Peering ######################################

// creates a route for HVN to aws via the vpc
resource "hcp_hvn_route" "hvn_vpc_route" {
  count            = var.vpc_peering ? 1 : 0
  hvn_link         = data.hcp_hvn.hvn.self_link
  hvn_route_id     = var.hvn_route_id
  destination_cidr = var.destination_cidr
  target_link      = hcp_aws_network_peering.hvn_aws_peer[0].self_link
}

// creates a peering request with aws for a flat hvn
resource "hcp_aws_network_peering" "hvn_aws_peer" {
  count           = var.vpc_peering ? 1 : 0

  hvn_id          = data.hcp_hvn.hvn.hvn_id
  peering_id      = var.hvn_peering_id
  peer_vpc_id     = var.vpc_id
  peer_account_id = var.vpc_owner_id
  peer_vpc_region = var.vpc_region
}

// accept the peering request between hvn and aws
resource "aws_vpc_peering_connection_accepter" "hvn_aws_vpc_accept" {
  count = var.vpc_peering ? 1 : 0
  vpc_peering_connection_id = hcp_aws_network_peering.hvn_aws_peer[0].provider_peering_id
  auto_accept               = true
  tags = {
    Name = var.hvn_peering_id
  }
}
###################################### END Single HVN VPC Peering ######################################

######################################  HVN Transit Gateway  #######################################

// associates the hcp provider id with the resource_share arn in aws
resource "aws_ram_principal_association" "hcp_aws_ram" {
  count              = var.transit_gateway ? 1 : 0

  resource_share_arn = var.resource_share_arn
  principal          = data.hcp_hvn.hvn.provider_account_id
}

// creates an attachment to the aws transit gateway from hvn
resource "hcp_aws_transit_gateway_attachment" "hvn_transit_gw" {
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
  count = var.transit_gateway ? 1 : 0
  transit_gateway_attachment_id = hcp_aws_transit_gateway_attachment.hvn_transit_gw[0].provider_transit_gateway_attachment_id
}

// creates a route from hvn to aws via the transit gateway
resource "hcp_hvn_route" "hvn_tgw_route" {
  for_each         = { for k, v in try(var.routes, []) : k => v if var.transit_gateway == true }
  hvn_link         = data.hcp_hvn.hvn.self_link
  hvn_route_id     = each.key
  destination_cidr = each.value
  target_link      = hcp_aws_transit_gateway_attachment.hvn_transit_gw[0].self_link
}

###################################### END HVN Transit Gateway #####################################

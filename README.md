<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.15 |
| <a name="requirement_hcp"></a> [hcp](#requirement\_hcp) | >=0.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.38.0 |
| <a name="provider_hcp"></a> [hcp](#provider\_hcp) | 0.47.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_vpc_attachment_accepter.hvn_aws_tgw_accept](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment_accepter) | resource |
| [aws_ram_principal_association.hcp_aws_ram](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_route.aws_vpc_to_hvn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_vpc_peering_connection_accepter.hvn_aws_vpc_accept](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [hcp_aws_network_peering.vpc_peer](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/aws_network_peering) | resource |
| [hcp_aws_transit_gateway_attachment.tgw](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/aws_transit_gateway_attachment) | resource |
| [hcp_hvn_route.hvn_tgw_route](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/hvn_route) | resource |
| [hcp_hvn_route.vpc_route](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/resources/hvn_route) | resource |
| [hcp_hvn.hvn](https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/data-sources/hvn) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_hvn_cidr_block"></a> [hvn\_cidr\_block](#input\_hvn\_cidr\_block) | (Required) CIDR block for the HVN VPC | `string` | n/a | yes |
| <a name="input_hvn_id"></a> [hvn\_id](#input\_hvn\_id) | The ID of the HCP HVN | `string` | n/a | yes |
| <a name="input_hvn_peering_id"></a> [hvn\_peering\_id](#input\_hvn\_peering\_id) | The Peering ID of the HCP Vault HVN. | `string` | `"hcp-hvn-peer"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region of the HCP HVN / Cluster. | `string` | `""` | no |
| <a name="input_resource_share_arn"></a> [resource\_share\_arn](#input\_resource\_share\_arn) | Amazon Resource Name of the Resource Share that is needed to grant HCP acces to the transit gateway | `string` | `""` | no |
| <a name="input_route_table_ids"></a> [route\_table\_ids](#input\_route\_table\_ids) | (Optional) List of the route table IDs in the AWS VPC | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_routes"></a> [routes](#input\_routes) | "Routes that will be created between HCP and AWS. The ID of the route should be used as the key and the subnet should be used as the value<br>  {<br>    "bastion" = "10.0.1.0/24"<br>    "gcp"     = "172.200.0.0/16"<br>  } | `map(string)` | n/a | yes |
| <a name="input_transit_gateway"></a> [transit\_gateway](#input\_transit\_gateway) | Flag to use an AWS transit gateway | `bool` | `false` | no |
| <a name="input_transit_gw_attachment_id"></a> [transit\_gw\_attachment\_id](#input\_transit\_gw\_attachment\_id) | Name of the transit gateway attachment for collapsed network in HVN | `string` | `"hcp-hvn-transit-gw"` | no |
| <a name="input_transit_gw_id"></a> [transit\_gw\_id](#input\_transit\_gw\_id) | ID of the transit gateway that exists in AWS that HCP will attach to | `string` | `""` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Peer ID from the AWS peering VPC | `string` | `""` | no |
| <a name="input_vpc_owner_id"></a> [vpc\_owner\_id](#input\_vpc\_owner\_id) | Peer account ID from AWS for the VPC that HCP will use. Only required if HCP is peering with a VPC that has a different owner than vpc\_owner\_id | `string` | `""` | no |
| <a name="input_vpc_peering"></a> [vpc\_peering](#input\_vpc\_peering) | Flag to enable vpc peering with HCP and AWS | `bool` | `false` | no |
| <a name="input_vpc_region"></a> [vpc\_region](#input\_vpc\_region) | Region where the AWS VPC was created | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hvn"></a> [hvn](#output\_hvn) | Output of the data block from the HCP HVN lookup |
| <a name="output_tgw_attachment"></a> [tgw\_attachment](#output\_tgw\_attachment) | Output map of the TGW attachment that are created. |
| <a name="output_tgw_hvn_routes"></a> [tgw\_hvn\_routes](#output\_tgw\_hvn\_routes) | Output map of the HVN routes that are created in HCP for the Transit Gateway |
| <a name="output_vpc_hvn_routes"></a> [vpc\_hvn\_routes](#output\_vpc\_hvn\_routes) | Output map of the VPC routes that have been created on the HCP HVN. |
| <a name="output_vpc_routes"></a> [vpc\_routes](#output\_vpc\_routes) | Output map of the VPC routes from that have been created in AWS. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

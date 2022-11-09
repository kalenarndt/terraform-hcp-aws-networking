module "hcp" {
  source                = "kalenarndt/hcp/hcp"
  version               = "~>0.1.0"
  region                = "us-west-2"
  vault_tier            = "dev"
  vault_public_endpoint = true
  single_hvn            = true
  create_vault_cluster  = true
  generate_vault_token  = true
  output_vault_token    = true
}

module "hcp-networking" {
  source          = "../../"
  hvn_id          = module.hcp.hvn_single_link
  vpc_peering     = true
  region          = "us-west-2"
  vpc_id          = "yourvpcid"
  vpc_owner_id    = "myownerid"
  route_table_ids = concat(["rtb-0cde02474debb9885"], ["rtb-0039f80242af3ba66"])
  hvn_cidr_block  = module.hcp.hvn_single_cidr_block
  routes = {
    "myvpc" = "10.0.0.0/16"
  }
}

# Example using the AWS VPC Module
/* module "hcp-networking" {
  source          = "../../"
  hvn_id          = module.hcp.hvn_single_link
  vpc_peering     = true
  region          = var.region
  vpc_id          = module.vpc.vpc_id
  vpc_owner_id    = module.vpc.vpc_owner_id
  route_table_ids = concat(module.vpc.private_route_table_ids, module.vpc.public_route_table_ids)
  hvn_cidr_block  = module.hcp.hvn_single_cidr_block
  routes = {
    "${module.vpc.name}" = "${module.vpc.vpc_cidr_block}"
  }
} */

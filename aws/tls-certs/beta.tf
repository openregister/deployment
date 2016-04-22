module "beta" {
  source = "../modules/certificate"
  id = "${lookup(var.beta, "name")}"
  enabled = "${lookup(var.beta, "enabled")}"
  path = "${lookup(var.beta, "path")}"
  certificate_file = "${lookup(var.beta, "certificate")}"
  private_key_file = "${lookup(var.beta, "private_key")}"
  chain_file = "${lookup(var.beta, "chain")}"
}

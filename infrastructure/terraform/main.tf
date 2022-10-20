data "oci_core_vcns" "lhtran_vcn" {
  compartment_id = var.compartment_id
  display_name   = var.vcn_display_name
}

data "oci_core_subnets" "public_subnets" {
  compartment_id = var.compartment_id
  vcn_id         = data.oci_core_vcns.lhtran_vcn.virtual_networks[0].id
}

data "oci_core_images" "ubuntu_aarch64" {
  compartment_id           = var.compartment_id
  operating_system         = var.os_name
  operating_system_version = var.os_version
  shape                    = var.shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

module "gatewise_instance" {
  source                = "oracle-terraform-modules/compute-instance/oci"
  version               = ">=2.4"
  instance_count        = 1 # how many instances do you want?
  ad_number             = 1 # AD number to provision instances. If null, instances are provisionned in a rolling manner starting with AD1
  compartment_ocid      = var.compartment_id
  instance_display_name = "ocipl-app-gatewise"
  source_ocid           = data.oci_core_images.ubuntu_aarch64.images[0].id
  subnet_ocids          = [for i in data.oci_core_subnets.public_subnets.subnets : i.id if startswith(i.display_name, "public")]
  public_ip             = "EPHEMERAL"
  ssh_public_keys       = var.public_key
  #block_storage_sizes_in_gbs = [50]
  shape                       = var.shape
  instance_flex_ocpus         = var.shape_ocpus
  instance_flex_memory_in_gbs = var.shape_memory
  freeform_tags = {
    "env" = "${var.env}"
    "module" : "oracle-terraform-modules/compute-instance/oci"
    "terraformed" : "Please do not edit manually"
  }
}

data "aws_route53_zone" "selected" {
  name         = format("%s%s", regex("^(?:(?P<record>[^\\.]+))?(?:.(?P<domain>[^/?#]*))?", var.hostname).domain, ".")
  private_zone = false
}

resource "aws_route53_record" "gatewise" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = regex("^(?:(?P<record>[^\\.]+))?(?:.(?P<domain>[^/?#]*))?", var.hostname).record
  type    = "A"
  ttl     = 300
  records = [for i in module.gatewise_instance.public_ip_all_attributes : i.ip_address]
}
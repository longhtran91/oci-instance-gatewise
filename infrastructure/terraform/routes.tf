data "oci_core_private_ips" "ocipl_app_gatewise" {
    vnic_id = module.gatewise_instance.vnic_attachment_all_attributes.0.vnic_attachments[0].vnic_id
}

resource "oci_core_route_table" "home_vpn_routes" {
    compartment_id = var.compartment_id
    vcn_id = data.oci_core_vcns.lhtran_vcn.virtual_networks[0].id

    display_name = "home_vpn_routes"
    freeform_tags   = {
        "env" = "${var.env}"
        "module": "oracle-terraform-modules/vcn/oci"
        "terraformed": "Please do not edit manually"
    }

    route_rules {
        network_entity_id = data.oci_core_private_ips.ocipl_app_gatewise.id
        destination = "1.1.1.1/32"
        destination_type = "CIRD_BLOCK"
    }

    # dynamic "route_rules"  {
    #   for_each = var.home_vpn_cidrs
    #   content {
    #     network_entity_id = data.oci_core_private_ips.ocipl_app_gatewise.id
    #     destination_type = "CIRD_BLOCK"
    #     destination = route_rules.value
    #   }
    # }
}
resource "oci_core_vcn" "non-prod-vcn" {
  cidr_block     = "172.16.0.0/16"
  compartment_id = var.compartment_id
  dns_label      = "non-prod"
  display_name   = "non-prod-vcn"
}

resource "oci_core_internet_gateway" "non-prod-vcn" {
  compartment_id = var.compartment_id
  display_name   = "non-prod Box"
  vcn_id         = oci_core_vcn.non-prod-vcn.id
  enabled        = true
}

resource "oci_core_route_table" "non-prod-vcn" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.non-prod-vcn.id
  display_name   = "non-prod Box"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.non-prod-vcn.id
  }
}

resource "oci_core_security_list" "non-prod-vcn-incoming" {
  display_name   = "Incoming traffic for non-prod Box"
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.non-prod-vcn.id

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    icmp_options {
      type = 0
    }

    protocol = 1
    source   = "0.0.0.0/0"
  }
  ingress_security_rules {
    icmp_options {
      type = 3
      code = 4
    }

    protocol = 1
    source   = "0.0.0.0/0"
  }
  ingress_security_rules {
    icmp_options {
      type = 8
    }

    protocol = 1
    source   = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_subnet" "non-prod-subnet" {
  cidr_block        = oci_core_vcn.non-prod-vcn.cidr_block
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.non-prod-vcn.id
  route_table_id    = oci_core_route_table.non-prod-vcn.id

  display_name      = "non-prod-subnet"
  dns_label         = "non-prod"
  security_list_ids = [
      oci_core_security_list.non-prod-vcn-incoming.id
  ]
}

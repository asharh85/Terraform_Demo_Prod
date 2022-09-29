resource "oci_core_vcn" "prod-vcn" {
  cidr_block     = "172.16.0.0/16"
  compartment_id = var.compartment_id
  dns_label      = "prod"
  display_name   = "prod-vcn"
}

resource "oci_core_internet_gateway" "prod-vcn" {
  compartment_id = var.compartment_id
  display_name   = "prod Box"
  vcn_id         = oci_core_vcn.prod-vcn.id
  enabled        = true
}

resource "oci_core_route_table" "prod-vcn" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.prod-vcn.id
  display_name   = "prod Box"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.prod-vcn.id
  }
}

resource "oci_core_security_list" "prod-vcn-incoming" {
  display_name   = "Incoming traffic for prod Box"
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.prod-vcn.id

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

resource "oci_core_subnet" "prod-subnet" {
  cidr_block        = oci_core_vcn.prod-vcn.cidr_block
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.prod-vcn.id
  route_table_id    = oci_core_route_table.prod-vcn.id

  display_name      = "prod-subnet"
  dns_label         = "prod"
  security_list_ids = [
      oci_core_security_list.prod-vcn-incoming.id
  ]
}

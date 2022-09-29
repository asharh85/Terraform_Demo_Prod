resource "oci_core_instance" "proddbox1" {
  availability_domain = "Pjgw:US-ASHBURN-AD-1"
  compartment_id      = var.compartment_id
  shape               = "VM.Standard1.1"
  display_name        = "Prod Terraform Demo Box"

  agent_config {
    is_monitoring_disabled = true
  }

  create_vnic_details {
    assign_public_ip = true
    display_name     = "Primary VNIC"
    hostname_label   = "proddbox1"
    subnet_id        = oci_core_subnet.prod-subnet.id
  }

  # metadata = {
  #   ssh_authorized_keys = var.ssh_authorized_key
  # }

  source_details {
    source_id   = "ocid1.image.oc1.iad.aaaaaaaakv7vhpdllpbotmmjvxus3j5nh6wt2n43ddcg3cl5fnq5p6kngkza"
    source_type = "image"
  }
}

output "proddbox1-Public-IP" {
  value = [oci_core_instance.proddbox1.public_ip]
}

resource "oci_core_instance" "proddbox2" {
  availability_domain = "Pjgw:US-ASHBURN-AD-1"
  compartment_id      = var.compartment_id
  shape               = "VM.Standard1.1"
  display_name        = "Prod Terraform Demo Box 2"

  agent_config {
    is_monitoring_disabled = true
  }

  create_vnic_details {
    assign_public_ip = true
    display_name     = "Primary VNIC"
    hostname_label   = "proddbox2"
    subnet_id        = oci_core_subnet.prod-subnet.id
  }

  # metadata = {
  #   ssh_authorized_keys = var.ssh_authorized_key
  # }

  source_details {
    source_id   = "ocid1.image.oc1.iad.aaaaaaaakv7vhpdllpbotmmjvxus3j5nh6wt2n43ddcg3cl5fnq5p6kngkza"
    source_type = "image"
  }
}

output "proddbox2-Public-IP" {
  value = [oci_core_instance.proddbox2.public_ip]
}

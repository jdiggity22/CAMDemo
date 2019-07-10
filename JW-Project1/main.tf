#####################################################################
##
##      Created 7/10/19 by admin. For Cloud vCenter for project1
##
#####################################################################

terraform {
  required_version = "> 0.8.0"
}

provider "vsphere" {
  user           = "${var.user}"
  password       = "${var.password}"
  vsphere_server = "${var.vsphere_server}"

  allow_unverified_ssl = "${var.allow_unverified_ssl}"
  version = "~> 1.2"
}


data "vsphere_virtual_machine" "camdemo_template" {
  name          = "${var.camdemo_template_name}"
  datacenter_id = "${data.vsphere_datacenter.camdemo_datacenter.id}"
}

data "vsphere_datacenter" "camdemo_datacenter" {
  name = "${var.camdemo_datacenter_name}"
}

data "vsphere_datastore" "camdemo_datastore" {
  name          = "${var.camdemo_datastore_name}"
  datacenter_id = "${data.vsphere_datacenter.camdemo_datacenter.id}"
}

resource "vsphere_virtual_machine" "camdemo" {
  name          = "${var.camdemo_name}"
  datastore_id  = "${data.vsphere_datastore.camdemo_datastore.id}"
  num_cpus      = "${var.camdemo_number_of_vcpu}"
  memory        = "${var.camdemo_memory}"
  guest_id = "${data.vsphere_virtual_machine.camdemo_template.guest_id}"
  resource_pool_id = "${var.camdemo_resource_pool}"
  clone {
    template_uuid = "${data.vsphere_virtual_machine.camdemo_template.id}"
  }
  disk {
    name = "${var.camdemo_disk_name}"
    size = "${var.camdemo_disk_size}"
  }
}
packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1"
    }
  }
}

variable "image_name" {
  type    = string
  default = "riscv-ubuntu"
}

variable "ssh_password" {
  type    = string
  default = "12345"
}

variable "ssh_username" {
  type    = string
  default = "gem5"
}


locals {
  iso_data = {
    iso_url       = "./../tmp/ubuntu-24.04-preinstalled-server-riscv64.img"
    iso_checksum  = "sha256:9f1010bfff3d3b2ed3b174f121c5b5002f76ae710a6647ebebbc1f7eb02e63f5"
    output_dir    = "riscv-disk-image-24-04"
  }
}

source "qemu" "initialize" {
  cpus             = "17"
  format           = "raw"
  headless         = "true"
  disk_image       = "true"
  boot_command = [
                  "<wait10><enter>",
                  "<wait80>",
                  "ubuntu<enter><wait>",
                  "ubuntu<enter><wait>",
                  "ubuntu<enter><wait>",
                  "12345678<enter><wait>",
                  "12345678<enter><wait>",
                  "<wait20>",
                  "sudo adduser gem5<enter><wait10>",
                  "12345<enter><wait10>",
                  "12345<enter><wait10>",
                  "<enter><enter><enter><enter><enter>y<enter><wait>",
                  "sudo usermod -aG sudo gem5<enter><wait>",
                  "sudo sh -c 'echo \"export DEBIAN_FRONTEND=noninteractive\" > /etc/profile.d/debian_noninteractive.sh'<enter><wait>",
                  "sudo sh -c 'echo \"DEBIAN_FRONTEND=noninteractive\" >> /etc/environment'<enter><wait>",
                  "sudo debconf-set-selections <<< \"debconf debconf/frontend select Noninteractive\"<enter><wait>",
                  "sudo debconf-set-selections <<< \"debconf debconf/priority select critical\"<enter><wait>"
                ]
  iso_checksum     = local.iso_data.iso_checksum
  iso_urls         = [local.iso_data.iso_url]
  memory           = "16384"
  output_directory = local.iso_data.output_dir
  qemu_binary      = "/usr/bin/qemu-system-riscv64"

  qemuargs       = [  ["-bios", "/usr/lib/riscv64-linux-gnu/opensbi/generic/fw_jump.elf"],
                      ["-machine", "virt"],
                      ["-kernel","/usr/lib/u-boot/qemu-riscv64_smode/uboot.elf"],
                      ["-device", "virtio-vga"],
                      ["-device", "qemu-xhci"],
                      ["-device", "usb-kbd"]
                  ]
  shutdown_command = "echo '${var.ssh_password}'|sudo -S shutdown -P now"
  ssh_password     = "${var.ssh_password}"
  ssh_username     = "${var.ssh_username}"
  ssh_wait_timeout = "60m"
  vm_name          = "${var.image_name}"
  ssh_handshake_attempts = "1000"
}

build {
  sources = ["source.qemu.initialize"]

  provisioner "file" {
    destination = "/home/gem5/"
    source      = "files/exit.sh"
  }

  provisioner "file" {
    destination = "/home/gem5/"
    source      = "files/riscv/gem5_init.sh"
  }

  provisioner "file" {
    destination = "/home/gem5/"
    source      = "files/riscv/after_boot.sh"
  }

  provisioner "file" {
    destination = "/home/gem5/"
    source      = "files/serial-getty@.service-override.conf"
  }

  provisioner "file" {
    destination = "/home/gem5"
    source      = "6.8.12"
  }
  
  provisioner "shell" {
    execute_command = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    scripts         = [
                       "../common/scripts/install-common-packages.sh",
                       "../common/scripts/update-modules-riscv.sh",
                       "../common/scripts/update-gem5-init.sh",
                       "../common/scripts/install-gem5-bridge.sh"
                      ]
    environment_vars = ["ISA=riscv"]
    expect_disconnect = true
  }

  provisioner "shell" {
    execute_command = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    scripts         = [
                       "../common/scripts/disable-systemd-services-riscv.sh",
                       "../common/scripts/disable-network.sh"
                      ]
    environment_vars = ["ISA=riscv"]
    expect_disconnect = true
  }
}

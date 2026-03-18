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
  default = "riscv-gapbs"
}

variable "ssh_password" {
  type    = string
  default = "12345"
}

variable "ssh_username" {
  type    = string
  default = "gem5"
}

source "qemu" "initialize" {
  cpus             = "4"
  disk_size        = "10G"
  format           = "raw"
  headless         = "true"
  disk_image       = "true"
  boot_command = [
                 "<wait120>", // If the build process is hanging during login, the `<wait>` commands may need to be adjusted.
                  "gem5<enter><wait10>",
                  "12345<enter><wait10>",
                  "sudo mount -o remount,rw /<enter><wait10>", // remounting system as read-write as qemu does not like that we have m5 exits in the boot process so it mounts system as read ony.
                  "12345<enter><wait10>",
                  "sudo growpart /dev/vda 1<enter><wait10>",
                  "12345<enter><wait10>",
                  "sudo resize2fs /dev/vda1<enter><wait10>",
                  "12345<enter><wait10>",
                  "sudo mv /etc/netplan/50-cloud-init.yaml.bak /etc/netplan/50-cloud-init.yaml<enter><wait10>",
                  "sudo netplan apply<enter><wait10>",
                  "<wait>"
                ]
  iso_checksum     = "sha256:ddf1ebb56454ef37e88d6de8aefdef7180fc9a2328a3bf8cff02f7a043e7127b"
  iso_urls         = ["./../tmp/riscv-ubuntu-24.04-20250515"]
  memory           = "8192"
  output_directory = "riscv-disk-image-24-04"
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
  provisioner "shell" {
    execute_command = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    scripts         = [
                       "../common/scripts/install-common-packages.sh",
                       "scripts/install-gapbs.sh"
                      ]
    environment_vars = ["ISA=riscv"]
    expect_disconnect = true
  }
}
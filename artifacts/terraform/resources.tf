
resource "aws_instance" "options-vm" {
  count = "${var.instance_count}"

  ami           = "${var.ami}"
  instance_type = "${var.instance}"
  key_name      = "${var.private_key}"

  vpc_security_group_ids = [
    "${var.secgroupname}"
  ]


  ebs_block_device {
    device_name           = "/dev/sdg"
    volume_size           = 20
    volume_type           = "gp2"
    encrypted             = false
    delete_on_termination = true
  }

  connection {
    private_key = "${file(var.private_key_file)}"
    user        = "${var.ansible_user}"
    host = self.public_ip
  }

  # Ansible requires Python to be installed on the remote machine as well as the local machine.
  provisioner "remote-exec" {
    inline = ["sudo apt update -y","sudo apt-get install python3 -y"]
  }
  
  provisioner "local-exec" {
    command = "ansible-playbook"
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False  ansible-playbook -u ${var.ansible_user} --private-key /jenkeys/${var.private_key}.pem -i ${aws_instance.options-vm.0.public_ip}, ../playbooks/install_modules.yaml"
  }

 
  tags = {
    Name     = "options-scanner-${count.index +1 }"
  }
}


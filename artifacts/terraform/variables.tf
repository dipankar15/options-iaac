
variable "region" {
  default = "us-west-2"
}

variable "instance" {
  default = "t2.micro"
}

variable "instance_count" {
  default = "1"
}


variable "private_key" {
  default = "options-key"
}
variable "private_key_file" {
  default = "/jenkeys/options-key.pem"
}

variable "ansible_user" {
  default = "ubuntu"
}

variable "secgroupname" {
    default = "sg-bc687cc5"
}

variable "ami" {
  default = "ami-0d70546e43a941d70"
}

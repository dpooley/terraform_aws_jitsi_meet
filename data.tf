
# Fetch the image id for our ec2 instance
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Fetch our external IP
data "http" "external_ip" {
  url = "http://ipv4.icanhazip.com/"
}

# Get cloudflare
data "cloudflare_zones" "zone" {
  filter {
    name   = var.domainname
    status = "active"
    paused = false
  }
}

# Load our install script into a template_file
data "template_file" "install_script" {
  template = "${file("install_jitsi.tpl")}"
  vars = {
    email_address = var.email_address
    domain_name   = "${var.hostname}.${var.domainname}"
  }
}
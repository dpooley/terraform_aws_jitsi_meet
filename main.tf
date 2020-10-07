
# Create ssh key in aws
resource "aws_key_pair" "ssh" {
  key_name   = "ssh-jitsi"
  public_key = file(var.ssh_public_key_path)
}

# Request an IP address
resource "aws_eip" "ip" {
  vpc      = true
  instance = aws_instance.jitsi-meet-server.id
}

# Create an instance
resource "aws_instance" "jitsi-meet-server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.allow_connections_jitsi-meet.id]
  key_name               = aws_key_pair.ssh.key_name
  user_data              = data.template_file.install_script.rendered
  monitoring             = true
  tags = {
    Name = "${var.hostname}.${var.domainname}"
  }
}

# Create DNS record
resource "cloudflare_record" "server" {
  zone_id = data.cloudflare_zones.zone.zones[0].id
  name    = var.hostname
  type    = "A"
  value   = aws_eip.ip.public_ip
}
resource "cloudflare_record" "jitsi" {
  for_each = toset(var.dns_records)
  zone_id = data.cloudflare_zones.zone.zones[0].id
  name    = "${each.value}.${var.hostname}"
  type    = "A"
  value   = aws_eip.ip.public_ip
}

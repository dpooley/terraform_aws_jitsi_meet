output "ip_address" {
  value = aws_eip.ip.public_ip
}
output "ssh_command" {
  value = "ssh -l ubuntu ${aws_eip.ip.public_ip}"
}
output "jitsi_url" {
  value = "https://${var.hostname}.${var.domainname}"
}
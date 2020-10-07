variable "aws_region" {
  description = "Region where the instance should be located"
  default     = "ap-southeast-2"
}

variable "instance_type" {
  description = "Instance type to launch"
  default     = "t2.large"
}

variable "ssh_public_key_path" {
  description = "Path to the AWS SSH key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "ip_whitelist" {
  description = "All allowed ingress IPs"
  default     = ["0.0.0.0/0"]
}

variable "email_address" {
  description = "Email to use for the certificate generation"
  default     = "youremail@example.com"
}

variable "domainname" {
  description = "Your org domain name"
  default     = "example.com"
}
variable "hostname" {
  description = "Hostname of server"
  default     = "vc"
}

variable "dns_records" {
  description = "Additional Jitsi DNS records to be added"
  default = [
    "conference",
    "auth",
    "focus",
    "jitsi-videobridge"
  ]
}

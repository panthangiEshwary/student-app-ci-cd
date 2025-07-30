# Bastion Host
output "bastion_public_ip" {
  description = "The public IP address of the Bastion Host"
  value       = aws_instance.host.public_ip
}
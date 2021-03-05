output "ip" {
  value = aws_instance.bastion.public_ip
}

output "public_key_ssh" {
  value = tls_private_key.bastion.public_key_openssh
}

output "private_key_pem" {
  value = tls_private_key.bastion.private_key_pem
}

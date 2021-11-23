output "public_ip" {
value = module.aws_instance.public_ip
}

output "private_key_pem" {
value = module.aws_instance.private_key_pem
sensitive = true
}

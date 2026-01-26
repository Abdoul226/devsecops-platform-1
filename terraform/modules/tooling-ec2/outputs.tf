output "instance_id" { value = aws_instance.tooling.id }
output "public_ip" { value = aws_instance.tooling.public_ip }
output "security_group_id" { value = aws_security_group.tooling.id }


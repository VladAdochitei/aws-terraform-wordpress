# EC2 module outputs

output "instance_ec2_id" {
    value = aws_instance.web_server.id
    description = "The id of the ec2 instance"
}

output "instance_ec2_public_ip" {
    value = aws_instance.web_server.public_ip
    description = "The public IP assigned to the ec2 instance"
}

output "instance_ec2_private_ip" {
    value = aws_instance.web_server.public_ip
    description = "The private IP associated to the ec2 instance"
}

output "eip" {
    value = aws_eip.elastic_ip_wordpress[0].public_ip
}
# RDS module outputs

output "db_name" {
    value = aws_db_instance.db-wordpress.db_name
    description = "The name of the database"
}

output "db_endpoint" {
    value = aws_db_instance.db-wordpress.endpoint 
    description = "The database's endpoint, will be used to connect to the server"
}

output "db_id" {
    value  = aws_db_instance.db-wordpress.id
    description = "The database's id"
}

output "db_address" {
    value = aws_db_instance.db-wordpress.address
    description = "The database's address, similar to the endpoint"
}
# Prerequisite configuration variables
variable "db_subnet_group" {
    type = list(string)
    description = "The subnet group of the database"
}

variable "db_name_identifier" {
    type = string
    description = "The Name tag of the database"
}

# db configuration INITIAL

variable "db_allocated_storage" {
    type        = number
    default     = 10
    description = "storage allocated (GiB)"
}

variable "db_engine" {
    type    = string
    default = "mysql"
    description = "The database engine"
}

variable "db_engine_version" {
    type    = string
    default = "5.7"
    description = "The database engine version"
}

variable "db_instance_class" {
    type        = string
    default     = "db.t3.micro"
    description = "type of instance, it's performance, etc"
}

variable "db_name" {
    type = string
    description = "The database's name, !NOT name tag !will be used by the server to connect to the database"
}

variable "db_username" {
    type    = string
    default = "administrator"
    description = "The database's username !will be used by the server to connect to the database"
}

variable "db_password" {
    type    = string
    default = "parola1234"
    description = "The database's password !will be used by the server to connect to the database"
}

variable "db_skip_final_snapshot" {
    type    = bool
    default = true
    description = "Configuration argument that will skip or notskipthe final snapshot"
}



# in depth variables for db setup
variable "db_vpc_security_group_ids" {
    type = list(string)
    description = "the list of security groups that need to be associated with our db"
}

variable "db_availability_zone" {
    type = string
    #default = "us-east-1a"
    description = "The az that the db resides in"
}
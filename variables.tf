variable "aws_region" {
  description = "The AWS region to deploy resources into."
  type        = string
  default     = "us-east-1"
}

variable "log_group_name" {
  description = "log group name"
  type        = string
  default     = "studentLog"
}

variable "my_ip_cidr" {
  description = "Your public IP address in CIDR format for SSH access (e.g., 203.0.113.45/32)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
  default     = "student-app-cluster"
}

variable "db_master_username" {
  description = "Master username for the RDS PostgreSQL database"
  type        = string
  default     = "student_db"
}

variable "db_master_password" {
  description = "Master password for the RDS PostgreSQL database"
  type        = string
  sensitive   = true
  default     = "password"
}

variable "key_pair_name" {
  description = "Name of the EC2 Key Pair for SSH access"
  type        = string
  default     = "eshawary"
}
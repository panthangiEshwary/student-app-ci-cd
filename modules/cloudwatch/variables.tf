variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "alb_id" {
  description = "ALB resource ID"
  type        = string
}

variable "ecs_cluster_name" {
  type = string
}


variable "ecs_service_name" {
  description = "ECS service name"
  type        = string
}

variable "rds_instance_id" {
  description = "RDS instance identifier"
  type        = string
}

variable "log_group_name" {
  description = "CloudWatch log group name"
  type        = string
}

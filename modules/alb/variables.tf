variable "vpc_id" {
    description = "The ID of the VPC"
  type        = string
}
variable "alb_sg_id" {
    description = "The ID of the ALB security group"
  type        = string

}
variable "public_subnet_ids" {
  type = list(string)
}

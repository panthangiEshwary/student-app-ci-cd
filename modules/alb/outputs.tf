output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.student_app_alb.arn
}

output "alb_id" {
  description = "The ID of the Application Load Balancer"
  value       = aws_lb.student_app_alb.id
}

output "alb_dns_name" {
  value = aws_lb.student_app_alb.dns_name
}

output "alb_target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.student_app_tg.arn
}

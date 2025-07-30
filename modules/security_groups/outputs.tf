output "bastion_sg_id" {
  value = aws_security_group.student_bastion_sg.id
}
output "alb_sg_id" {
  value = aws_security_group.student_alb_sg.id
}
output "ecs_fargate_sg_id" {
  value = aws_security_group.student_ecs_fargate_sg.id
}
output "rds_sg_id" {
  value = aws_security_group.student_rds_sg.id
}

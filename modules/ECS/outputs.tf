output "ecs_cluster_id" {
  value = aws_ecs_cluster.student_app_cluster.id
}

output "ecs_service_name" {
  value = aws_ecs_service.student_app_service.name
}
output "ecs_cluster_name" {
  value = aws_ecs_cluster.student_app_cluster.name
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.ecs_app_logs.name
}

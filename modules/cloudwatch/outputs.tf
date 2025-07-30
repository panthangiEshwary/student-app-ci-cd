output "cloudwatch_dashboards" {
  description = "List of CloudWatch dashboards created"
  value = [
    aws_cloudwatch_dashboard.student_app_overview.dashboard_name,
    aws_cloudwatch_dashboard.student_app_health.dashboard_name,
    aws_cloudwatch_dashboard.student_app_db_dashboard.dashboard_name
  ]
}

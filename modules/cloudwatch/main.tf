resource "aws_cloudwatch_dashboard" "student_app_overview" {
  dashboard_name = "StudentApp-Overview"
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x    = 0,
        y    = 0,
        width = 12,
        height = 6,
        properties = {
          metrics = [
            [ "AWS/ApplicationELB", "RequestCount", "LoadBalancer", var.alb_id ]
          ],
          view       = "timeSeries",
          stacked    = false,
          region     = var.aws_region,
          title      = "ALB Request Count"
        }
      },
      {
        type = "metric",
        x    = 12,
        y    = 0,
        width = 12,
        height = 6,
        properties = {
          metrics = [
            [ "AWS/ECS", "CPUUtilization", "ClusterName", var.ecs_cluster_name, "ServiceName", var.ecs_service_name ]
          ],
          view    = "timeSeries",
          stacked = false,
          region  = var.aws_region,
          title   = "ECS CPU Utilization"
        }
      },
      {
        type = "metric",
        x    = 0,
        y    = 6,
        width = 12,
        height = 6,
        properties = {
          metrics = [
            [ "AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.rds_instance_id ]
          ],
          view    = "timeSeries",
          stacked = false,
          region  = var.aws_region,
          title   = "RDS CPU Utilization"
        }
      },
      {
        type = "metric",
        x    = 12,
        y    = 6,
        width = 12,
        height = 6,
        properties = {
          metrics = [
            [ "StudentApp/Flask", "RequestCount" ]
          ],
          view    = "timeSeries",
          stacked = false,
          region  = var.aws_region,
          title   = "Flask App Requests"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_dashboard" "student_app_health" {
  dashboard_name = "StudentApp-Health"
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x    = 0,
        y    = 0,
        width = 24,
        height = 6,
        properties = {
          metrics = [
            [ "AWS/ECS", "MemoryUtilization", "ClusterName", var.ecs_cluster_name, "ServiceName", var.ecs_service_name ],
            [ ".", "CPUUtilization", ".", ".", ".", "." ]
          ],
          view    = "timeSeries",
          stacked = false,
          region  = var.aws_region,
          title   = "ECS Cluster Health"
        }
      },
      {
        type = "metric",
        x    = 0,
        y    = 6,
        width = 24,
        height = 6,
        properties = {
          metrics = [
            [ "StudentApp/Flask", "ErrorCount" ],
            [ ".", "Latency" ]
          ],
          view    = "timeSeries",
          stacked = false,
          region  = var.aws_region,
          title   = "Flask App Errors and Latency"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_dashboard" "student_app_db_dashboard" {
  dashboard_name = "StudentApp-DBDashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x    = 0,
        y    = 0,
        width = 12,
        height = 6,
        properties = {
          metrics = [
            [ "AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", var.rds_instance_id ]
          ],
          view    = "timeSeries",
          stacked = false,
          region  = var.aws_region,
          title   = "RDS DB Connections"
        }
      },
      {
        type = "metric",
        x    = 12,
        y    = 0,
        width = 12,
        height = 6,
        properties = {
          metrics = [
            [ "AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", var.rds_instance_id ]
          ],
          view    = "timeSeries",
          stacked = false,
          region  = var.aws_region,
          title   = "RDS Free Storage Space"
        }
      },
      {
        type = "log",
        x    = 0,
        y    = 6,
        width = 24,
        height = 6,
        properties = {
          query  = "SOURCE '${var.log_group_name}' | fields @timestamp, @message | sort @timestamp desc | limit 20",
          region = var.aws_region,
          title  = "ECS Logs"
        }
      }
    ]
  })
}

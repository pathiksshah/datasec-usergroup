terraform {
	required_providers {
		dsfhub = {
			source = "imperva/dsfhub"
		}
	}
}

provider "dsfhub" {
  dsfhub_host  = var.dsfhub_host
  dsfhub_token = var.dsfhub_token
}


# data "aws_kinesis_stream" "kinesis_stream" {
#   name = aws_rds_cluster_activity_stream.aurora_mysql_activity_stream.kinesis_stream_name
# }
 
# resource "aws_iam_policy" "kinesis_policy" {
#   name        = "DSFAgentlessGatewayKinesisPolicy-${var.deployment_name}"
#   description = "DSF Agentless Gateway Kinesis Policy for ${var.deployment_name}"
 
#   policy = jsonencode({
#   "Version": "2012-10-17",
#   "Statement": [
#       {
#         "Sid": "VisualEditor0",
#         "Effect": "Allow",
#         "Action": [
#           "kinesis:GetShardIterator",
#           "kinesis:GetRecords",
#           "kinesis:DescribeStream",
#           "kms:Decrypt"
#         ]
#         "Resource": [
#           "${data.aws_kinesis_stream.kinesis_stream.arn}",
#         ]
#       }
#     ]
#   })
#   tags = var.additional_tags
# }
 
# resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
#   policy_arn = aws_iam_policy.kinesis_policy.arn
#   role       = var.agentless_gateway_iam_role_name
# }

# data "aws_cloudwatch_log_group" "postgresql_cluster_log_group_primary" {
#   name        = "/aws/rds/cluster/${aws_rds_cluster.aurora_pg_cluster.cluster_identifier}/postgresql"
# }


# data "aws_iam_role" "agentless_gateway" {
#   name = var.agentless_gateway_iam_role_name
# }

# resource "aws_iam_policy" "log_group_policy" {
#   name        = "DSFAgentlessGatewayLogGroupPolicy-${var.deployment_name}"
#   description = "DSF Agentless Gateway Log Group Policy for ${var.deployment_name}"

#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Sid": "VisualEditor0",
#         "Effect": "Allow",
#         "Action": [
#           "logs:DescribeLogGroups",
#           "logs:DescribeLogStreams",
#           "logs:FilterLogEvents",
#           "logs:GetLogEvents"
#         ]
#         "Resource": [
#           "${data.aws_cloudwatch_log_group.postgresql_cluster_log_group_primary.arn}:*",
#         ]
#       }
#     ]
#   })
#   tags = var.additional_tags
# }

# resource "aws_iam_role_policy_attachment" "log_group_policy_attachment" {
#   policy_arn = aws_iam_policy.log_group_policy.arn
#   role       = data.aws_iam_role.agentless_gateway.name
# }

# # DSFHUB Resources ###
# data "aws_caller_identity" "current" {}
 
# data "aws_partition" "current" {}
 
# data "aws_region" "current" {}
 
# resource "dsfhub_data_source" "demo_aws_rds_aurora_mysql_cluster" {
#   server_type = "AWS RDS AURORA MYSQL CLUSTER"
 
#   admin_email        = var.admin_email
#   asset_display_name = aws_rds_cluster.aurora_mysql_cluster.cluster_identifier
#   asset_id           = aws_rds_cluster.aurora_mysql_cluster.arn
#   gateway_id         = var.gateway_id
#   server_host_name   = aws_rds_cluster.aurora_mysql_cluster.endpoint
 
#   audit_pull_enabled = true
 
#   audit_type      = "KINESIS"
#   cluster_id      = aws_rds_cluster.aurora_mysql_cluster.cluster_identifier
#   cluster_name    = aws_rds_cluster.aurora_mysql_cluster.cluster_identifier
#   is_cluster      = true
#   database_name   = aws_rds_cluster.aurora_mysql_cluster.database_name
#   parent_asset_id = var.dsf_cloud_account_asset_id
#   region          = data.aws_region.current.name
#   server_port     = aws_rds_cluster.aurora_mysql_cluster.port
#   enable_audit_monitoring = false
# }
 

# resource "dsfhub_log_aggregator" "demo_aws_kinesis" {
#   depends_on = [
#     aws_rds_cluster_activity_stream.aurora_mysql_activity_stream,
#     dsfhub_data_source.demo_aws_rds_aurora_mysql_cluster
#   ]
 
#   server_type = "AWS KINESIS"
 
#   admin_email        = var.admin_email
#   asset_display_name = "arn:${data.aws_partition.current.partition}:kinesis:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:stream/${aws_rds_cluster_activity_stream.aurora_mysql_activity_stream.kinesis_stream_name}"
#   asset_id           = "arn:${data.aws_partition.current.partition}:kinesis:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:stream/${aws_rds_cluster_activity_stream.aurora_mysql_activity_stream.kinesis_stream_name}"
#   gateway_id         = var.gateway_id
#   parent_asset_id    = aws_rds_cluster.aurora_mysql_cluster.arn
#   audit_pull_enabled = true
 
#   asset_connection {
#     auth_mechanism = "default"
#     reason         = "default"
#     region         = data.aws_region.current.name
#   }
# }

# resource "dsfhub_data_source" "rds-postgresql-cluster" {
#   depends_on  = [aws_rds_cluster.aurora_pg_cluster]
#   server_type = "AWS RDS AURORA POSTGRESQL CLUSTER"

#   admin_email         = var.admin_email
#   asset_display_name  = aws_rds_cluster.aurora_pg_cluster.cluster_identifier
#   asset_id            = aws_rds_cluster.aurora_pg_cluster.arn
#   gateway_id          = var.gateway_id
#   server_host_name    = aws_rds_cluster.aurora_pg_cluster.endpoint
#   region              = data.aws_region.current.name
#   server_port         = aws_rds_cluster.aurora_pg_cluster.port
#   version             = var.db_engine_version
#   parent_asset_id     = var.dsf_cloud_account_asset_id
#   audit_pull_enabled  = true

#   asset_connection {
#     auth_mechanism  = "password"
#     password        = var.db_master_password
#     reason          = "default"
#     username        = var.db_master_username
#   }
# }

# resource "dsfhub_log_aggregator" "demo_aws_log_group_default" {
#   server_type = "AWS LOG GROUP"
#   admin_email = var.admin_email    
#   asset_display_name = data.aws_cloudwatch_log_group.postgresql_cluster_log_group_primary.name # User-friendly name of the asset, defined by user.
#   asset_id = data.aws_cloudwatch_log_group.postgresql_cluster_log_group_primary.arn # The unique identifier or resource name of the asset. For AWS, use arn, for Azure, use subscription ID, for GCP, use project ID
#   gateway_id = var.gateway_id # The jsonarUid unique identifier of the agentless gateway. Example: '7a4af7cf-4292-89d9-46ec-183756ksdjd'
#   parent_asset_id = dsfhub_data_source.rds-postgresql-cluster.asset_id # The name of an asset that this asset is part of (/related to). E.g. an AWS resource will generally have an AWS account asset as its parent. Also used to connect some log aggregating asset with the sources of their logs. E.g. An AWS LOG GROUP asset can have an AWS RDS as its parent, indicating that that is the log group for that RDS.
#   asset_connection {
#     auth_mechanism = "default"
#     reason = "default"
#     region = data.aws_region.current.name # For cloud systems with regions, the default region or region used with this asset
#   }
#   audit_pull_enabled = true
# }
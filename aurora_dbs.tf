provider "aws" {
  region = var.region
}


# 1. Custom Parameter Group
resource "aws_rds_cluster_parameter_group" "rds_aurora_postgresql_cluster_pg" {

  name        = "${var.deployment_name}-pg-parameter-group"
  description = "${var.deployment_name}-pg-parameter-group"
  family      = var.pg_db_family

  parameter {
    apply_method = "immediate"
    name         = "log_connections"
    value        = "1"
  }
  parameter {
    apply_method = "immediate"
    name         = "log_disconnections"
    value        = "1"
  }
  parameter {
    apply_method = "immediate"
    name         = "log_error_verbosity"
    value        = "verbose"
  }
  parameter {
    apply_method = "immediate"
    name         = "pgaudit.log"
    value        = "all"
  }
  parameter {
    apply_method = "immediate"
    name         = "pgaudit.role"
    value        = "rds_pgaudit"
  }
  parameter {
    apply_method = "pending-reboot"
    name         = "shared_preload_libraries"
    value        = "pgaudit,pg_stat_statements"
  }

}
# 2. Aurora DB Cluster
resource "aws_rds_cluster" "aurora_pg_cluster" {
    engine                    = "aurora-postgresql"
    engine_version            = var.db_engine_version
    cluster_identifier        = "cluster-${lower(var.db_name)}pg"
    master_username           = var.db_master_username
    master_password           = var.db_master_password
    database_name             = "${lower(var.db_name)}pg"
    #db_subnet_group_name      = var.db_subnet_group_name
    skip_final_snapshot       = true
  # audit
    enabled_cloudwatch_logs_exports = ["postgresql"]
    db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.rds_aurora_postgresql_cluster_pg.name
    tags = var.additional_tags
}

# 3. DB Instance in the Cluster (writer)
resource "aws_rds_cluster_instance" "aurora_pg_instance" {
  engine               = "aurora-postgresql"
  engine_version       = var.db_engine_version
  identifier           = "instance-${lower(var.db_name)}-pg"
  cluster_identifier   = aws_rds_cluster.aurora_pg_cluster.id
  instance_class       = "db.r5.large"
  tags = var.additional_tags
}


# DB parameter group
resource "aws_rds_cluster_parameter_group" "aurora_mysql_paramter_group" {
  name        = "${var.deployment_name}-mysql-parameter-group"
  description = "${var.deployment_name}-mysql-parameter-group"
  family      = var.mysql_db_family
 
  parameter {
    name  = "server_audit_logging"
    value = "1"
  }
 
  parameter {
    name  = "server_audit_events"
    value = "CONNECT,QUERY,QUERY_DCL,QUERY_DDL,QUERY_DML"
  }
 
  parameter {
    name  = "server_audit_excl_users"
    value = "rdsadmin"
  }
}
 
# Aurora cluster
resource "aws_rds_cluster" "aurora_mysql_cluster" {
  depends_on = [aws_rds_cluster_parameter_group.aurora_mysql_paramter_group]
 
  cluster_identifier              = "cluster-${lower(var.db_name)}-mysql"
  database_name                   = "${lower(var.db_name)}mysql"
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_mysql_paramter_group.name
  engine                          = "aurora-mysql"
  engine_version                  = var.mysql_db_engine_version
  master_username                 = var.db_master_username
  master_password                 = var.db_master_password
  skip_final_snapshot             = true
  tags = var.additional_tags
}
 
# DB instance
resource "aws_rds_cluster_instance" "aurora_mysql_instance" {
  depends_on = [aws_rds_cluster.aurora_mysql_cluster]
 
  identifier          = var.db_cluster_instance_name
  cluster_identifier  = aws_rds_cluster.aurora_mysql_cluster.id
  instance_class      = var.db_cluster_instance_class
  engine              = aws_rds_cluster.aurora_mysql_cluster.engine
  engine_version      = aws_rds_cluster.aurora_mysql_cluster.engine_version
  publicly_accessible = true
  tags = var.additional_tags
}
 
# KMS key
resource "aws_kms_key" "aurora_mysql_kms_key" {
  description = "AWS KMS Key to encrypt Aurora MySQL Database Activity Stream"
  tags = var.additional_tags
}
 
# Database activity (kinesis) stream
resource "aws_rds_cluster_activity_stream" "aurora_mysql_activity_stream" {
  depends_on = [aws_rds_cluster_instance.aurora_mysql_instance, aws_kms_key.aurora_mysql_kms_key]
 
  resource_arn = aws_rds_cluster.aurora_mysql_cluster.arn
  mode         = "async"
  kms_key_id   = aws_kms_key.aurora_mysql_kms_key.key_id
}






 




# DSFHUB Asset Variables
variable "admin_email" {
  description = "The email address to notify about this asset"
  type = string
  
}

variable "region" {
  type = string
  
}

variable "deployment_name" {
  description = "The name of the database deployment. i.e. 'aurora-demo-db-cluster-pg'"
  type = string
  default = "user-group-demo-pg"
}

variable "db_allocated_storage" {
  description = "The allocated storage in gibibytes. If max_allocated_storage is configured, this argument represents the initial storage allocation and differences from the configuration will be ignored automatically when Storage Autoscaling occurs. If replicate_source_db is set, the value is ignored during the creation of the instance."
  type = number
  default = 20
}

variable "db_cluster_instance_class" {
  description = "The instance type of the RDS instance. Example: 'db.t2'. Reference: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html"
  type = string
  default = "db.r5.large"
}

variable "db_cluster_instance_name" {
  description = "Identifier for the RDS instance"
  type = string
  default = "usergroup-demo-cluster"
}

variable "pg_db_engine_version" {
  description = "Database engine version, i.e. \"11.9\""
  type = string
  default = "11.9"
}

variable "mysql_db_engine_version" {
  description = "Database engine version, i.e. \"11.9\""
  type = string
  default = "8.0"
}

variable "pg_db_family" {
  description = "The family of the DB parameter group. Example: 'aurora-postgresql13'."
  type        = string
  default     = "aurora-postgresql11"
}

variable "mysql_db_family" {
  description = "The family of the DB parameter group"
  type        = string
  default     = "aurora-mysql8.0"
}

variable "pg_db_identifier" {
  type        = string
  description = "Identifier of RDS instance"
  default = "aurora-demo-db-cluster-pg"
}

variable "mysql_db_identifier" {
  type        = string
  description = "Identifier of RDS instance"
  default = "aurora-demo-db-cluster-mysql"
}

variable "db_instance_class" {
  description = "The instance type of the RDS instance. Example: 'db.t2'. Reference: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html"
  type = string
  default = "db.t3.medium"
}


variable "db_master_username" {
  description = "Username for the master DB user, must not use rdsamin as that is reserved. Cannot be specified for a replica."
  type = string
  
}

variable "db_master_password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file."
  type = string
  
}

variable "db_name" {
  description = "The database name (must begin with a letter and contain only alphanumeric characters)."
  type = string
  
}

variable "pg_db_parameter_group_family" {
  description = "Database engine version, i.e. \"aurora-postgresql13\""
  type = string
  default = "aurora-postgresql13"
}



variable "additional_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}

# DSFHUB Provider Required Variables
variable "dsfhub_token" {   
} # TF_VAR_dsfhub_token env variable
variable "dsfhub_host" {
} # TF_VAR_dsfhub_host env variable



variable "gateway_id" {
  description =  "The jsonarUid unique identifier of the agentless gateway in the primary region. Example: '7a4af7cf-4292-89d9-46ec-183756ksdjd'"
  type = string
}

variable "agentless_gateway_iam_role_name" {
  type = string
}


variable "db_engine_version" {
  description = "Database engine version, i.e. \"11.9\""
  type = string
  default = "11.9"
}

variable "dsf_cloud_account_asset_id" {
  type = string
}





variable "irsa_role_arn" { type = string }

variable "region" { type = string }
variable "secret_store_name" { type = string }
variable "create_cluster_secret_store" { type = bool}
variable "sa_name" { type = string}
variable "sa_namespace" { type = string}
variable "namespaces" { type = map(object({ name = string, remote_key = string })) }
variable "mysql_ca_property" { type = string}
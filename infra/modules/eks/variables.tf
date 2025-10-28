variable "instance_types" {
    type = list(string)
}
variable "min_size" {
    type = number
}
variable "max_size" {
    type = number
}
variable "desired_size" {
    type = number
}
variable "capacity_type" {
    type = string
}
variable "ami_type" {
    type = string
}
variable "vpc_id" {
    type = string
}
variable "private_subnets" {
    type = list(string)
}
variable "api_public_cidrs" {
    type = list(string)
}

variable "environment" {
    type = string
}


variable "eso_policy_arn" {
    type = string
}
variable "kubernetes_version" {
    type = string
}
variable "token" {
  description = "TFE Org Token"
}

variable "aws_region" {
  description = "region to deploy resources in"
  default     = "us-east-2"
}

variable "use_case_name" {}

variable "org" {}

variable "hostname" {}

variable "vcs_identifier" {}

variable "oauth_token" {}

variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "destroy_vars" {
  type = "list"
}

variable "destroy_keys" {
  type = "list"
}

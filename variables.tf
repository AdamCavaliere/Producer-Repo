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

variable "sub_account_aws_access_key" {}

variable "sub_account_aws_secret_key" {}

variable "master_aws_access_key" {}

variable "master_aws_secret_key" {}

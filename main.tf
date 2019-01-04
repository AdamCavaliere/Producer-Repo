provider "tfe" {
  hostname = "${var.hostname}"
  token    = "${var.token}"
}

resource "tfe_workspace" "development" {
  name         = "${var.use_case_name}-development"
  organization = "${var.org}"
  auto_apply   = true

  vcs_repo = {
    branch         = "development"
    identifier     = "${var.vcs_identifier}"
    oauth_token_id = "${var.oauth_token}"
  }
}

resource "tfe_workspace" "staging" {
  name         = "${var.use_case_name}-staging"
  organization = "${var.org}"
  auto_apply   = true

  vcs_repo = {
    branch         = "staging"
    identifier     = "${var.vcs_identifier}"
    oauth_token_id = "${var.oauth_token}"
  }
}

resource "tfe_workspace" "production" {
  name         = "${var.use_case_name}-production"
  organization = "${var.org}"

  vcs_repo = {
    identifier     = "${var.vcs_identifier}"
    oauth_token_id = "${var.oauth_token}"
  }
}

resource "tfe_variable" "staging_aws_access_key" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = "${var.aws_access_key}"
  category     = "env"
  workspace_id = "${tfe_workspace.staging.id}"
}

resource "tfe_variable" "development_aws_access_key" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = "${var.aws_access_key}"
  category     = "env"
  workspace_id = "${tfe_workspace.development.id}"
}

resource "tfe_variable" "production_aws_access_key" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = "${var.aws_access_key}"
  category     = "env"
  workspace_id = "${tfe_workspace.production.id}"
}

resource "tfe_variable" "staging_aws_secret_key" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = "${var.aws_secret_key}"
  category     = "env"
  sensitive    = "true"
  workspace_id = "${tfe_workspace.staging.id}"
}

resource "tfe_variable" "development_aws_secret_key" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = "${var.aws_secret_key}"
  category     = "env"
  sensitive    = "true"
  workspace_id = "${tfe_workspace.development.id}"
}

resource "tfe_variable" "production_aws_secret_key" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = "${var.aws_secret_key}"
  category     = "env"
  sensitive    = "true"
  workspace_id = "${tfe_workspace.production.id}"
}

resource "tfe_variable" "workspace_var_staging" {
  key      = "workspace_name"
  value    = "${var.creator_workspace}"
  category = "terraform"

  workspace_id = "${tfe_workspace.staging.id}"
}

resource "tfe_variable" "workspace_var_development" {
  key      = "workspace_name"
  value    = "${var.creator_workspace}"
  category = "terraform"

  workspace_id = "${tfe_workspace.development.id}"
}

resource "tfe_variable" "workspace_var_production" {
  key      = "workspace_name"
  value    = "${var.creator_workspace}"
  category = "terraform"

  workspace_id = "${tfe_workspace.production.id}"
}

resource "tfe_variable" "org_var_production" {
  key          = "org"
  value        = "${var.org}"
  category     = "terraform"
  workspace_id = "${tfe_workspace.production.id}"
}

resource "tfe_variable" "org_var_development" {
  key          = "org"
  value        = "${var.org}"
  category     = "terraform"
  workspace_id = "${tfe_workspace.development.id}"
}

resource "tfe_variable" "org_var_staging" {
  key      = "org"
  value    = "${var.org}"
  category = "terraform"

  workspace_id = "${tfe_workspace.staging.id}"
}

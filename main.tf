provider "tfe" {
  hostname = "${var.hostname}"
  token    = "${var.token}"
}

resource "tfe_team" "developers" {
  name         = "${var.use_case_name}-developers"
  organization = "${var.org}"
}

resource "tfe_team" "ops" {
  name         = "${var.use_case_name}-production"
  organization = "${var.org}"
}

resource "tfe_team_member" "azc-dev" {
  team_id  = "${tfe_team.developers.id}"
  username = "azc-dev"
}

resource "tfe_team_member" "azc-ops" {
  team_id  = "${tfe_team.ops.id}"
  username = "azc-ops"
}

resource "tfe_team_access" "development" {
  access       = "admin"
  team_id      = "${tfe_team.developers.id}"
  workspace_id = "${tfe_workspace.development.id}"
}

resource "tfe_team_access" "staging" {
  access       = "write"
  team_id      = "${tfe_team.developers.id}"
  workspace_id = "${tfe_workspace.staging.id}"
}

resource "tfe_team_access" "production" {
  access       = "read"
  team_id      = "${tfe_team.developers.id}"
  workspace_id = "${tfe_workspace.production.id}"
}

resource "tfe_team_access" "production-ops" {
  access       = "admin"
  team_id      = "${tfe_team.ops.id}"
  workspace_id = "${tfe_workspace.production.id}"
}

resource "tfe_workspace" "development" {
  name         = "${var.use_case_name}-development"
  organization = "${var.org}"
  auto_apply   = true
  depends_on   = ["null_resource.github_mgmt"]

  vcs_repo = {
    branch         = "development"
    identifier     = "${var.git_user}/${var.git_repo}"
    oauth_token_id = "${var.oauth_token}"
  }
}

resource "tfe_workspace" "staging" {
  name         = "${var.use_case_name}-staging"
  organization = "${var.org}"
  auto_apply   = true
  depends_on   = ["null_resource.github_mgmt"]

  vcs_repo = {
    branch         = "staging"
    identifier     = "${var.git_user}/${var.git_repo}"
    oauth_token_id = "${var.oauth_token}"
  }
}

resource "tfe_workspace" "production" {
  name         = "${var.use_case_name}-production"
  organization = "${var.org}"
  depends_on   = ["null_resource.github_mgmt"]

  vcs_repo = {
    identifier     = "${var.git_user}/${var.git_repo}"
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

resource "tfe_variable" "confirm_destroy1" {
  key          = "CONFIRM_DESTROY"
  value        = "1"
  category     = "env"
  workspace_id = "${tfe_workspace.development.id}"
}

resource "tfe_variable" "confirm_destroy2" {
  key          = "CONFIRM_DESTROY"
  value        = "1"
  category     = "env"
  workspace_id = "${tfe_workspace.staging.id}"
}

resource "tfe_variable" "confirm_destroy3" {
  key          = "CONFIRM_DESTROY"
  value        = "1"
  category     = "env"
  workspace_id = "${tfe_workspace.production.id}"
}

resource "tfe_variable" "set_ttl1" {
  key          = "WORKSPACE_TTL"
  value        = "30"
  category     = "env"
  workspace_id = "${tfe_workspace.development.id}"
}

resource "tfe_variable" "set_ttl2" {
  key          = "WORKSPACE_TTL"
  value        = "30"
  category     = "env"
  workspace_id = "${tfe_workspace.staging.id}"
}

resource "tfe_variable" "set_ttl3" {
  key          = "WORKSPACE_TTL"
  value        = "30"
  category     = "env"
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

resource "tfe_variable" "environment_name_dev" {
  key      = "environment"
  value    = "development"
  category = "terraform"

  workspace_id = "${tfe_workspace.development.id}"
}

resource "tfe_variable" "environment_name_stage" {
  key      = "environment"
  value    = "staging"
  category = "terraform"

  workspace_id = "${tfe_workspace.staging.id}"
}

resource "tfe_variable" "environment_name_prod" {
  key      = "environment"
  value    = "production"
  category = "terraform"

  workspace_id = "${tfe_workspace.production.id}"
}

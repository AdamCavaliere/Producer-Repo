provider "tfe" {
  hostname = var.hostname
  token    = var.token
}

resource "tfe_team" "developers" {
  name         = "${var.use_case_name}-developers"
  organization = var.org
}

resource "tfe_team" "ops" {
  name         = "${var.use_case_name}-production"
  organization = var.org
}

resource "tfe_team_member" "dev-user" {
  team_id  = "${tfe_team.developers.id}"
  username = "dev-user"
}

resource "tfe_team_member" "ops-user" {
  team_id  = "${tfe_team.ops.id}"
  username = "ops-user"
}

resource "tfe_team_access" "development-dev" {
  access       = "admin"
  team_id      = "${tfe_team.developers.id}"
  workspace_id = "${tfe_workspace.development.id}"
}

resource "tfe_team_access" "stage-dev" {
  access       = "write"
  team_id      = "${tfe_team.developers.id}"
  workspace_id = "${tfe_workspace.stage.id}"
}

resource "tfe_team_access" "production-dev" {
  access       = "read"
  team_id      = "${tfe_team.developers.id}"
  workspace_id = "${tfe_workspace.production.id}"
}

resource "tfe_team_access" "production-ops" {
  access       = "admin"
  team_id      = "${tfe_team.ops.id}"
  workspace_id = "${tfe_workspace.production.id}"
}

resource "tfe_team_access" "stage-ops" {
  access       = "admin"
  team_id      = "${tfe_team.ops.id}"
  workspace_id = "${tfe_workspace.stage.id}"
}

resource "tfe_team_access" "development-ops" {
  access       = "admin"
  team_id      = "${tfe_team.ops.id}"
  workspace_id = "${tfe_workspace.development.id}"
}

resource "tfe_workspace" "development" {
  name         = "${var.use_case_name}-development"
  organization = var.org
  auto_apply   = true
  queue_all_runs = false
  terraform_version = "1.3.5"

  vcs_repo {
    branch         = "development"
    identifier     = var.vcs_identifier
    oauth_token_id = var.oauth_token
  }
}

resource "tfe_workspace" "stage" {
  name         = "${var.use_case_name}-stage"
  organization = var.org
  auto_apply   = true
  terraform_version = "1.3.5"

  vcs_repo {
    branch         = "stage"
    identifier     = var.vcs_identifier
    oauth_token_id = var.oauth_token
  }
}

resource "tfe_workspace" "production" {
  name         = "${var.use_case_name}-production"
  organization = var.org
  terraform_version = "1.3.5"

  vcs_repo {
    branch         = "main"
    identifier     = var.vcs_identifier
    oauth_token_id = var.oauth_token
  }
}

resource "tfe_variable" "staging_aws_access_key" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = var.aws_access_key
  category     = "env"
  workspace_id = "${tfe_workspace.stage.id}"
}

resource "tfe_variable" "development_aws_access_key" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = var.aws_access_key
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
  workspace_id = "${tfe_workspace.stage.id}"
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

  workspace_id = "${tfe_workspace.stage.id}"
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
  workspace_id = "${tfe_workspace.stage.id}"
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
  workspace_id = "${tfe_workspace.stage.id}"
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
  value    = var.org
  category = "terraform"

  workspace_id = "${tfe_workspace.stage.id}"
}

resource "tfe_variable" "environment_name_dev" {
  key      = "environment"
  value    = "dev"
  category = "terraform"

  workspace_id = "${tfe_workspace.development.id}"
}

resource "tfe_variable" "environment_name_stage" {
  key      = "environment"
  value    = "stage"
  category = "terraform"

  workspace_id = "${tfe_workspace.stage.id}"
}

resource "tfe_variable" "environment_name_prod" {
  key      = "environment"
  value    = "prod"
  category = "terraform"

  workspace_id = "${tfe_workspace.production.id}"
}

resource "tfe_variable" "name_dev" {
  key      = "name"
  value    = var.use_case_name
  category = "terraform"
  workspace_id = "${tfe_workspace.development.id}"
}

resource "tfe_variable" "name_stage" {
  key      = "name"
  value    = var.use_case_name
  category = "terraform"
  workspace_id = "${tfe_workspace.stage.id}"
}

resource "tfe_variable" "name_prod" {
  key      = "name"
  value    = var.use_case_name
  category = "terraform"
  workspace_id = "${tfe_workspace.production.id}"
}

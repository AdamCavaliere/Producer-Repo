provider "tfe" {
  hostname = "${var.hostname}"
  token    = "${var.token}"
}

resource "tfe_workspace" "development" {
  name              = "${var.use_case_name}-development"
  organization      = "${var.org}"

  vcs_repo = {
    branch         = "development"
    identifier     = "${var.vcs_identifier}"
    oauth_token_id = "${var.oauth_token}"
  }
}

resource "tfe_workspace" "staging" {
  name              = "${var.use_case_name}-staging"
  organization      = "${var.org}"

  vcs_repo = {
    branch         = "staging"
    identifier     = "${var.vcs_identifier}"
    oauth_token_id = "${var.oauth_token}"
  }
}

resource "tfe_workspace" "production" {
  name              = "${var.use_case_name}-production"
  organization      = "${var.org}"

  vcs_repo = {
    identifier     = "${var.vcs_identifier}"
    oauth_token_id = "${var.oauth_token}"
  }
}

resource "tfe_variable" "research_aws_access_key" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = "${var.sub_account_aws_access_key}"
  category     = "env"
  workspace_id = "${tfe_workspace.research.id}"
}

resource "tfe_variable" "test_aws_access_key" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = "${var.sub_account_aws_access_key}"
  category     = "env"
  workspace_id = "${tfe_workspace.test.id}"
}

resource "tfe_variable" "prod_aws_access_key" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = "${var.sub_account_aws_access_key}"
  category     = "env"
  workspace_id = "${tfe_workspace.prod.id}"
}

resource "tfe_variable" "research_aws_secret_key" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = "${var.sub_account_aws_secret_key}"
  category     = "env"
  sensitive    = "true"
  workspace_id = "${tfe_workspace.research.id}"
}

resource "tfe_variable" "test_aws_secret_key" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = "${var.sub_account_aws_secret_key}"
  category     = "env"
  sensitive    = "true"
  workspace_id = "${tfe_workspace.test.id}"
}

resource "tfe_variable" "prod_aws_secret_key" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = "${var.sub_account_aws_secret_key}"
  category     = "env"
  sensitive    = "true"
  workspace_id = "${tfe_workspace.prod.id}"
}

resource "tfe_variable" "workspace_var_research" {
  key      = "workspace_name"
  value    = "Creator_Example1"
  category = "terraform"

  workspace_id = "${tfe_workspace.research.id}"
}

resource "tfe_variable" "workspace_var_test" {
  key      = "workspace_name"
  value    = "Creator_Example1"
  category = "terraform"

  workspace_id = "${tfe_workspace.test.id}"
}

resource "tfe_variable" "workspace_var_prod" {
  key      = "workspace_name"
  value    = "Accenture_VAR"
  category = "terraform"

  workspace_id = "${tfe_workspace.prod.id}"
}

resource "tfe_variable" "org_var_prod" {
  key          = "org"
  value        = "${var.org}"
  category     = "terraform"
  workspace_id = "${tfe_workspace.prod.id}"
}

resource "tfe_variable" "org_var_test" {
  key          = "org"
  value        = "${var.org}"
  category     = "terraform"
  workspace_id = "${tfe_workspace.test.id}"
}

resource "tfe_variable" "org_var_research" {
  key      = "org"
  value    = "${var.org}"
  category = "terraform"

  workspace_id = "${tfe_workspace.research.id}"
}

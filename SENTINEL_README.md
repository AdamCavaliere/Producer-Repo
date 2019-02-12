# Overview
Follow this README to setup a workspace used to demonstrate Sentinel policies being managed via VCS
Based on this article on the Terraform.io docs: https://www.terraform.io/docs/enterprise/sentinel/integrate-vcs.html

## Assumptions 
You have already followed the steps to configure the Producer Consumer demo environments in your TFE SaaS or pTFE instance
This guides assumes Github is being used for a VCS and that it has already been configured in your TFE org

Producer
https://github.com/AdamCavaliere/Producer-Repo
Consumer
https://github.com/AdamCavaliere/Consumer-Repo

# Setup 

### Fork me
* Fork this repo: https://github.com/hashicorp/tfe-policies-example/
### Log into TFE
* Log into your TFE or pTFE environment and choose the organization you are working in
### Create a workspace
* Create a workspace called "sentinel_policies"
* Configure VCS to point to your forked copy of the tfe-policies-example repo, (default branch)
* Configure the following Terraform variables for the workspace:
  - tfe_token <your tfe user token>
  - tfe_organization <your tfe org>
  - tfe_hostname <app.terraform.io> or your pTFE host name
  
* Configure the following Environment variables for the workspace:
  - CONFIRM_DESTROY < 1 >
### Modify some code
* In the root of the forked tfe-policies-example repo find the main.tf file
* Modify main.tf
### IF YOU ARE A TFE SaaS user SKIP THIS STEP
* If you are using pTFE modify this stanza to include your hostname and organization 
```
terraform {
  backend "remote" {
    hostname     = "<your_pTFE_hostname>"
    organization = "<your_org_name>"

    workspaces {
      name = "tfe-policies-example"
    }
  }
} 
```
### This demo is going to hardcode some values pre-created via the Producer Consumer demo creation 
* Find this resource stanza:
```
resource "tfe_policy_set" "production" {
  name         = "production"
  description  = "Policies that should be enforced on production infrastructure."
  organization = "${var.tfe_organization}"

  policy_ids = [
    "${tfe_sentinel_policy.aws-restrict-instance-type-prod.id}",
  ]

  workspace_external_ids = [
    "${local.workspaces["app-prod"]}",
  ]
}
```
* This is used by the TFE provider to create a Sentinel policy set, in this case called "production"
* The section `workspace_external_ids =` is used to add workspaced to the policy set that will be governed by the policies
* Now we want to hardcode the name of the production workspace you created in the Producer Consumer demo build out
```
workspace_external_ids = [
    "${local.workspaces["ExampleTeam-production"]}",
  ]
```
* Repeat this hardcode step for the `resource "tfe_policy_set" "development"` 
```
workspace_external_ids = [
    "${local.workspaces["ExampleTeam-development"]}",
  ]
```
* Repeat this hardcode step for the `resource "tfe_policy_set" "sentinel"` 
```
workspace_external_ids = [
    "${local.workspaces["sentinel_policies"]}",
  ]
```
* Commit the changes to the main.tf in your forked repo
## Test the deployment of sentinel policies
* When you committed the changes to the main.tf in the previous steps that would have kicked off a plan in your sentinel_policies workspace or your workspace my still be sitting at the initial setup screen for the workspace
* Queue a manual run of the sentinel_policies workspace 
* If you get a successful plan you are in good shape, now apply the run
* Go to the Org Settings for TFE, click on Policies and Policy Sets links to review the sentinel policies created and the policiy sets




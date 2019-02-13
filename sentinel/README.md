# Overview
Follow this README to setup a workspace used to demonstrate Sentinel policies being managed via VCS.
This example is based on this article on the Terraform.io docs: https://www.terraform.io/docs/enterprise/sentinel/integrate-vcs.html

## Assumptions 
You have already followed the steps to configure the Producer Consumer demo environments in your TFE SaaS or pTFE instance.
This guide assumes Github is being used for a VCS and that it has already been configured in your TFE org

Producer
https://github.com/AdamCavaliere/Producer-Repo
Consumer
https://github.com/AdamCavaliere/Consumer-Repo

# Setup 
### Log into TFE
* Log into your TFE or pTFE environment and choose the organization you are working in
### Create a workspace
* Create a workspace called "sentinel_policies"
* Configure VCS to point to your forked copy of the Producer-Repo, (default branch)
* For the sentinel_policies workspace click on Settings > General > 
  - TERRAFORM WORKING DIRECTORY set it to `sentinel` this will link to the sentinel sub directory in the parent repo
* Configure the following Terraform variables for the workspace:
  - tfe_token <your tfe user token>
  - tfe_organization <your tfe org>
  - tfe_hostname <app.terraform.io> or your pTFE host name
  
* Configure the following Environment variables for the workspace:
  - CONFIRM_DESTROY < 1 >

### IF YOU ARE A pTFE user PERFORM THIS STEP
* In the root of the sentinel directory find the `main.tf` file
* Modify main.tf
* If you are using pTFE modify this stanza to include your hostname and organization 
```
terraform {
  backend "remote" {
    hostname     = "<your_pTFE_hostname>"
    organization = "<your_org_name>"    
  }
} 
```
### This demo is has some hardcoded values to reference workspaces pre-created via the Producer Consumer demo creation 
* While still in the `main.tf` Verify that you are using the workspace names the Producer demo repo set, find these sections to update with your workspace names
```
resource "tfe_policy_set" "production" {
  name         = "production"
  description  = "Policies that should be enforced on production infrastructure."
  organization = "${var.tfe_organization}"

  policy_ids = [
    "${tfe_sentinel_policy.aws-restrict-instance-type-prod.id}",
  ]

  workspace_external_ids = [
    "${local.workspaces["ExampleTeam-production"]}", 
  ]
}
```
* The above stanza is used by the TFE provider to create a Sentinel policy set, in this case called "production"
* The section `workspace_external_ids =` is used to add workspaces to the policy set that will be governed by the policies
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
* Repeat this hardcode step for the `resource "tfe_policy_set" "development"` 
```
workspace_external_ids = [
    "${local.workspaces["ExampleTeam-staging"]}",
  ]
```
* Repeat this hardcode step for the `resource "tfe_policy_set" "sentinel"` 
```
workspace_external_ids = [
    "${local.workspaces["sentinel_policies"]}",
  ]
```
* Commit the changes to the main.tf 
## Test the deployment of sentinel policies
* When you committed the changes to the main.tf in the previous steps that would have kicked off a plan in your sentinel_policies workspace, or your workspace my still be sitting at the initial setup screen for the workspace
* Note that commiting changes to the sentinel directory will also trigger plans on the Producer workspace but should not detect any infrastructure changes.  
* Queue a manual run of the `sentinel_policies` workspace 
* If you get a successful plan you are in good shape, now apply the run
* Go to the Org Settings for TFE, click on Policies and Policy Sets links to review the sentinel policies created and the policiy sets
* If you didn't get a successful apply verify the hardcoded values in the `sentinel/main.tf` file.
* Now that you know the `sentinel_policies` workspace is functional clean up by running a destroy
* In the `sentinel_policies` workspace click on Settings > Destruction and Deletion > Queue destroy Plan
* You will demo the workspace VCS run later in your demo

# Post Setup demo info
## Create a new Sentinel policy via the TFE GUI
* Log into the TFE GUI, switch to your Org, then click on upper nav bar > Settings > Policies > Create a new policy
  - Policy name: aws-enforce-tags
  - Description: A sentinel policy that enforces a certain tag on AWS instances
  - Enforcement mode: Hard-mandatory 
  - Policy Code:
```
import "tfplan"

main = rule {
  all tfplan.resources.aws_instance as _, instances {
    all instances as _, r {
      r.applied contains "tags" and
      r.applied.tags contains "Name"
    }
  }
}
```
* Click Create Policy

## Create a Policy Set
* Click Policy Sets > Create a new policy set 
  - NAME `test-policy-set`
  - DESCRIPTION `test bed for sentinel policies`
  - SCOPE OF POLICIES radio button `Policies enforced on selected workspaces`
  - Policies > select from the dropdown `aws_enforce_tags` and click Add Policy 
  - Workspaces > select from the dropdown `ExampleTeam-development` and click Add Workspace
  - Click Update Policy set button
## Modify a consumer environment 
* Go to the Consumer-Repo that you cloned during the Producer Consumer demo setup
* Switch to the development branch 
* Edit the `main.tf` 
  - find the `resource "aws_instance" "web" ` stanza
  - Comment out the tags section
```
/* tags {
    Name = "Research Instance"
  } */
```
* Commit the change 
## Verify the run on a workspace
* Go to the `ExampleTeam-development` workspace
* The previous commit should have triggered a run
* We should see the plan succeed 
* Sentinel check should fail due to the lack of a tag with `Name`  
* If this doesn't work check the previous steps 
* After a successful plan and check failure, delete this manually created sentinel policy and policy set
* You will now shift into the VCS management of Sentinel policies in tfe

## Use a workspace to apply and manage Sentinel policies via VCS
* Go to the `sentinel_policies` workspace
* Trigger a manual run via Queue Plan
* You now have some additional policies to demonstrate 

## Production Change Window use case
To help drive home the whole story of Sentinel, VCS, and overall governance use these demo steps
* Go to the `ExampleTeam-production` workspace
* Trigger a run either via a VCS change to the `main.tf` file or via the Queue Plan 
* This should pass a plan and policy check, you can discard the apply if there are changes to make to the infrastructure
* Now go to the Producer Repo > Sentinel directory
* Edit the `main.tf`
  - Find the `resource "tfe_policy_set" "production"` stanza
* There is a policy that is commented out
```
policy_ids = [
    "${tfe_sentinel_policy.aws-restrict-instance-type-prod.id}",
 -> #"${tfe_sentinel_policy.prod-change-window-hours.id}", 
  ]
```
* Un-comment this line to include the `prod-change-windows-hours` sentinel policy
* Commit the changest to `main.tf`
* This will trigger a plan in the `sentinel_policies` workspace 
* Accept the apply on this change 
* Go back to the `ExampleTeam-production` workspace and trigger a run 
* This time the policy check will fail to indicate that you are attempting to make a change to production outside of the approved change window
* You have now demonstrated Sentinel policy creation via the GUI, and via a VCS workflow

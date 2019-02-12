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
* Create a workspace called "sentinel_policies"
* Configure VCS to point to your forked copy of the tfe-policies-example repo, (default branch)
* Configure the following Terraform variables for the workspace:
  - tfe_token <your tfe user token>
  - tfe_organization <your tfe org>
  - tfe_hostname <app.terraform.io> or your pTFE host name
  
* Configure the following Environment variables for the workspace:
  - CONFIRM_DESTROY < 1 >


  


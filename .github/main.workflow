workflow "Terraform" {
  resolves = "terraform-plan"
  on = "pull_request"
}

action "filter-to-pr-open-synced" {
  uses = "actions/bin/filter@master"
  args = "action 'opened|synchronize'"
}

action "terraform-fmt" {
  uses = "hashicorp/terraform-github-actions/fmt@v0.3.3"
  needs = "filter-to-pr-open-synced"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "./terraform-hcl"
  }
}

action "terraform-init" {
  uses = "hashicorp/terraform-github-actions/init@v0.3.3"
  needs = "terraform-fmt"
  secrets = [
    "GITHUB_TOKEN",
    "TF_ACTION_TFE_TOKEN",
  ]
  env = {
    TF_ACTION_WORKING_DIR = "./terraform-hcl"
  }
}

action "terraform-validate" {
  uses = "hashicorp/terraform-github-actions/validate@v0.3.3"
  needs = "terraform-init"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "./terraform-hcl"
  }
}

action "terraform-plan" {
  uses = "hashicorp/terraform-github-actions/plan@v0.3.3"
  needs = "terraform-validate"
  secrets = [
    "GITHUB_TOKEN",
    "TF_ACTION_TFE_TOKEN",
  ]
  env = {
    TF_ACTION_WORKING_DIR = "./terraform-hcl"
    # If you're using Terraform workspaces, set this to the workspace name.
    TF_ACTION_WORKSPACE = "default"
  }
}

provider "github" {
  # Credentials come from environment variables set via tfe_test_variable
  # (GITHUB_APP_ID, GITHUB_APP_INSTALLATION_ID, GITHUB_APP_PEM_FILE)
  # or from GITHUB_TOKEN if you prefer a PAT for testing.

  # owner is often required when using GitHub App auth
  # owner = "amiasea"   # or make it a variable if needed

  owner = "amiasea"

  app_auth {}
}

run "pomology" {
  command = apply

  variables {
    repo_name_prefix = "test"

    pomology = {
      cordons = jsondecode(file("tests/pomology.json")).cordons
    }
  }

  assert {
    condition = (
      length(output.variety_cordon_repositories) == length(var.pomology.cordons) &&
      alltrue([
        for cordon_name, result in output.variety_cordon_repositories :
        result.cordon.name == cordon_name &&
        result.cordon.repository_name != "" &&
        result.cordon.repository_node_id != "" &&
        length(result.varieties) == length(var.pomology.varieties) &&
        alltrue([
          for variety_name in var.pomology.varieties :
          contains(keys(result.varieties), variety_name) &&
          alltrue([
            for leaf_name, leaf in result.varieties[variety_name].leaves :
            leaf.repository_name != "" &&
            leaf.repository_node_id != "" &&
            leaf.option == var.pomology.cordons[cordon_name].leaves[leaf_name].options[variety_name]
          ])
        ])
      ])
    )

    error_message = "Each Cordon must expose its repository name and node ID, every declared variety, and each leaf's repository name, node ID, and correct selected option."
  }
}
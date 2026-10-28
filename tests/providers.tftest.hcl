provider "github" {
  # Credentials come from environment variables set via tfe_test_variable
  # (GITHUB_APP_ID, GITHUB_APP_INSTALLATION_ID, GITHUB_APP_PEM_FILE)
  # or from GITHUB_TOKEN if you prefer a PAT for testing.

  # owner is often required when using GitHub App auth
  # owner = "amiasea"   # or make it a variable if needed

  owner = "amiasea"

  app_auth {}
}
resource "github_repository" "this" {
  name       = "${var.repo_name_prefix}-${var.repo_name}"
  auto_init  = true
  visibility = var.repo_visibility
}

resource "github_branch" "source" {
  repository    = github_repository.this.name
  branch        = "development"
  source_branch = "main"

  depends_on = [
    github_repository.this
  ]
}
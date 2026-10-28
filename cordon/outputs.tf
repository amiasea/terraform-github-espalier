output "repository_name" {
  value = github_repository.this.name
}

output "repository_id" {
  value = github_repository.this.node_id
}
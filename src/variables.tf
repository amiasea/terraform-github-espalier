variable "repo_name_prefix" {
  description = "Prefix applied to every managed repository name."
  type        = string
  default     = "yoyo"
}

variable "repo_visibility" {
  description = "Repository visibility"
  type        = string
  default     = "public"
}

variable "github_app_id" {
  description = "GitHub App ID"
  type        = string
}

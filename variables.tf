variable "repo_name_prefix" {
  description = "Prefix applied to every managed repository name."
  type        = string
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

variable "pomology" {
  type = object({
    cordons = map(object({
      tier = string
      leaves = map(object({
        options = map(string)
      }))
    }))
  })
}
terraform {
  required_providers {
    github = {
      source = "integrations/github"
      version = "6.13.0"
    }

    external = {
      source  = "hashicorp/external"
      version = "~> 2.3"
    }
  }
}

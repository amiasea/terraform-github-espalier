terraform {
  required_providers {
    github = {
      source = "integrations/github"
      version = "6.13.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

provider "github" {
  owner = "amiasea"
}

provider "local" {
  
}
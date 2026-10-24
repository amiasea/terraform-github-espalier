resource "github_repository" "this" {
  name       = "${var.repo_name_prefix}-${var.repo_name}"
  auto_init  = true
  visibility = var.repo_visibility
}

data "external" "stream_seed" {
  program = ["pwsh", "-Command", <<-EOT
    $ErrorActionPreference = "Stop"

    # Read the query object Terraform sends on stdin
    $query = [Console]::In.ReadToEnd() | ConvertFrom-Json
    $repo  = $query.repo

    if (-not $repo) {
      throw "No 'repo' value received from Terraform query"
    }

    $emptyTreeSha = "4b825dc642cb6eb9a060e54bf8d69288fbee4904"

    $body = @{
      message = "Independent stream seed"
      tree    = $emptyTreeSha
      parents = @()
    } | ConvertTo-Json -Compress

    $tmp = [System.IO.Path]::GetTempFileName()
    [System.IO.File]::WriteAllText($tmp, $body, [System.Text.UTF8Encoding]::new($false))

    try {
      $resp = gh api --method POST "repos/$repo/git/commits" --input $tmp
      if ($LASTEXITCODE -ne 0) {
        throw "gh failed: $resp"
      }
      $sha = ($resp | ConvertFrom-Json).sha
    }
    finally {
      Remove-Item $tmp -ErrorAction SilentlyContinue
    }

    # Must return a flat JSON object
    @{ sha = $sha } | ConvertTo-Json -Compress
  EOT
  ]

  query = {
    repo = github_repository.this.full_name
  }
}

resource "github_repository_file" "stream_validation" {
  repository = github_repository.this.name

  file                = ".github/workflows/stream_validation.yml"
  content             = file("${path.module}/stream_validation.yml")
  branch              = "main"
  commit_message      = "Manage merge gate workflow"
  overwrite_on_create = true
}

resource "github_branch" "source" {
  repository    = github_repository.this.name
  branch        = "development"
  source_branch = "main"

  depends_on = [
    github_repository.this,
    github_repository_file.stream_validation
  ]
}
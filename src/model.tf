locals {
  model = jsondecode(file("${path.module}/model.json"))

  streams = toset(local.model.streams)

  cordons = {
    for cordon_name, cordon in local.model.cordons :
    cordon_name => {
      tier = cordon.tier

      leaves = {
        for leaf_name, leaf in cordon.leaves :
        leaf_name => {
          options = sort(distinct(values(leaf.options)))
        }
      }
    }
  }
}
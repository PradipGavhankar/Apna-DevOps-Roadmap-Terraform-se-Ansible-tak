variable "resource_groups" {

  description = "Map of Azure Resource Groups"

  type = map(object({

    name     = string
    location = string

  }))
}
variable "resource_group" {

  description = "Azure Resource Group configuration"

  type = object({
    name     = string
    location = string
    enabled  = bool
  })

}
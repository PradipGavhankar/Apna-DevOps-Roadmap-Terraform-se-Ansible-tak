variable "server_configuration" {

  description = "Server configuration"

  type = tuple([
    string,
    number,
    bool
  ])

}
# variable "map_roles" {
#   description = "Additional IAM roles to add to the aws-auth ConfigMap"
#   type = list(object({
#     rolearn  = string
#     username = string
#     groups   = list(string)
#   }))
#   default = []
# }
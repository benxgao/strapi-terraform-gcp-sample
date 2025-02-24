
# variables.tf
variable "project_id" {}
variable "region" {
  default = "australia-southeast1"
}
variable "zone" {
  default = "australia-southeast1-b"
}
variable "database_name" {
  default = "strapi"
}
variable "database_username" {}
variable "database_password" {}
variable "jwt_secret" {}
variable "admin_jwt_secret" {}
variable "node_env" {
  default = "production"
}
variable "strapi_version" {
  default = "3.6.8"
}
variable "strapi_adminer_version" {
  default = "4.8.0"
}

variable "repo_name" {
}

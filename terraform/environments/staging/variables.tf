# Variables (You might want to define these in variables.tf)

variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-b"
}

variable "db_name" {
  type    = string
  default = "strapi"
}

variable "db_user" {
  type    = string
  default = "strapi"
}

variable "db_pass" {
  type      = string
  default   = "strapi"
  sensitive = true
}


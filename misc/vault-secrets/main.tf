terraform {
  backend "s3" {
    bucket = "terraform-b83"
    key    = "vault-secrets/state"
    region = "us-east-1"
  }
}


provider "vault" {
  address = "http://vault-internal.rdevopsb83.online:8200"
  token = var.vault_token
}

variable "vault_token" {}

resource "vault_mount" "ssh" {
  path        = "infra"
  type        = "kv"
  options     = { version = "2" }
  description = "Infra secrets"
}

resource "vault_generic_secret" "ssh" {
  path = "${vault_mount.ssh.path}/ssh"

  data_json = <<EOT
{
  "username":   "ec2-user",
  "password": "DevOps321"
}
EOT
}

resource "vault_mount" "roboshop-dev" {
  path        = "roboshop-dev"
  type        = "kv"
  options     = { version = "2" }
  description = "Roboshop Dev secrets"
}

resource "vault_generic_secret" "roboshop-dev-cart" {
  path = "${vault_mount.roboshop-dev.path}/cart"

  data_json = <<EOT
{
"REDIS_HOST":   "redis-dev.rdevopsb83.online",
"CATALOGUE_HOST": "catalogue-dev.rdevopsb83.online",
"CATALOGUE_PORT": "8080"
}
EOT
}




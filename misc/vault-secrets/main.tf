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

resource "vault_generic_secret" "roboshop-dev-catalogue" {
  path = "${vault_mount.roboshop-dev.path}/catalogue"

  data_json = <<EOT
{
"MONGO":   "true",
"MONGO_URL": "mongodb://mongodb-dev.rdevopsb83.online:27017/catalogue"
}
EOT
}

resource "vault_generic_secret" "roboshop-dev-frontend" {
  path = "${vault_mount.roboshop-dev.path}/frontend"

  data_json = <<EOT
{
"catalogue_url":   "http://catalogue-dev.rdevopsb83.online:8080/",
"user_url":   "http://user-dev.rdevopsb83.online:8080/",
"cart_url":   "http://cart-dev.rdevopsb83.online:8080/",
"shipping_url":   "http://shipping-dev.rdevopsb83.online:8080/",
"payment_url":   "http://payment-dev.rdevopsb83.online:8080/"
}
EOT
}





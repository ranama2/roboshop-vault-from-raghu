variable "ami_id" {
  default = "ami-09c813fb71547fc4f"
}

variable "zone_id" {
  default = "Z01662431H5LL60AVTC0E"
}

variable "tools" {
  default = {

    vault = {
      instance_type     = "t3.small"
      port              = 8200
      root_block_device = 20
      iam_policy = {
        Action   = []
        Resource = []
      }
    }

    github-runner = {
      instance_type     = "t3.small"
      port              = 443 # Dummy port
      root_block_device = 30
      iam_policy = {
        Action   = ["*"]
        Resource = []
      }
    }

  }
}


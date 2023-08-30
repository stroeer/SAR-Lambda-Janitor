provider "aws" {
  region = var.region

  default_tags {
    tags = {
      managed_by = "terraform"
      service    = local.function_name
      source     = "https://github.com/stroeer/SAR-Lambda-Janitor"
    }
  }
}

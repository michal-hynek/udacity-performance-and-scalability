terraform {
  backend "s3" {
    bucket = "udacity-terraform-1469343"
    key = "final-project/part1/terraform.tfstate"
    region = "us-west-2"
  }
}
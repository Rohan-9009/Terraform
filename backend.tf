terraform {
  backend "s3" {
    bucket = "newterraformsamplebucket"
    key    = "Practice/terraform.tfstate"
    region = "ap-south-1"
    encrypt = "true"
    dynamodb_table = "My-dynamodb-table"
  }
}

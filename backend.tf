# terraform {
#   backend "s3" {
#     bucket         = "gregsharpe-tfstate"
#     key            = "gregsharpe-infra/<REPOSITORY_NAME>/<SUB_DIR_IF_EXIST>/terraform.state"
#     dynamodb_table = "gregsharpe-tfstate-lock"
#     region         = "eu-west-1"
#   }
# }

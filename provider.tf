provider aws {
  region = var.region
}

provider aws {
  alias  = "eu"
  region = "eu-west-1"
}

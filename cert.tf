resource aws_acm_certificate root_gregsharpe {
  domain_name               = "gregsharpe.co.uk"
  subject_alternative_names = ["*.gregsharpe.co.uk"]
  validation_method         = "EMAIL"

  lifecycle {
    create_before_destroy = true
  }
}

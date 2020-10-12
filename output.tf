output gregsharpe_acm_cert_arn {
  value = aws_acm_certificate.root_gregsharpe.arn
}

output gregsharpe_route53_zone_id {
  value = aws_route53_zone.root_gregsharpe.zone_id
}

resource "aws_sns_topic" "dashboard_alerts" {
  provider = aws.eu

  name = "aws-health-dashboard-alerts"
}

# resource "aws_sns_topic_subscription" "dashboard_alerts_email" {
#   provider = aws.eu

#   topic_arn = aws_sns_topic.dashboard_alerts.arn
#   protocol  = "email"
#   endpoint  = "aws+me@gregsharpe.co.uk"
# }

module "dashboard_alerts_slack" {
  source = "terraform-aws-modules/notify-slack/aws"

  sns_topic_name   = aws_sns_topic.dashboard_alerts.name
  create_sns_topic = false

  slack_webhook_url = var.sns_to_slack_url
  slack_channel     = "test-aws-sns"
  slack_username    = "AWS SNS"

  depends_on = [aws_sns_topic.dashboard_alerts]

  providers = {
    aws = aws.eu
  }
}

resource "aws_cloudwatch_event_rule" "dashboard_alerts" {
  provider = aws.eu

  name        = "aws-health-dashboard-alerts"
  description = "AWS Personal Health Dashboard alerts."

  event_pattern = <<EOF
{
  "source": [
    "aws.health"
  ],
  "detail-type": [
    "AWS Health Event"
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "sns" {
  provider = aws.eu

  rule      = aws_cloudwatch_event_rule.dashboard_alerts.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.dashboard_alerts.arn
}

resource "aws_sns_topic_policy" "default" {
  provider = aws.eu

  arn    = aws_sns_topic.dashboard_alerts.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.dashboard_alerts.arn]
  }
}

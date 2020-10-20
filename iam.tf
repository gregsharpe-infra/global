resource aws_iam_user terraform {
  name = "terraform-automation"
}

resource aws_iam_user_policy_attachment state_access {
  user       = aws_iam_user.terraform.name
  policy_arn = aws_iam_policy.state_access.arn
}

data aws_iam_policy_document state_access {
  statement {
    sid    = "StateBucketPutObjects"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::gregsharpe-tfstate/*"
    ]
  }
  statement {
    sid    = "StateBucketListBucket"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::gregsharpe-tfstate"
    ]
  }
  statement {
    sid    = "EncryptedBucketRequiresKMSPerms"
    effect = "Allow"
    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt"
    ]
    resources = [
      "arn:aws:kms:eu-west-1:001567907213:key/cc53b69b-8b8b-4b6d-b1cf-89ff415752c6"
    ]
  }
  statement {
    sid    = "StateDynamoDBAccess"
    effect = "Allow"
    actions = [
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:DeleteItem"
    ]
    resources = [
      "arn:aws:dynamodb:eu-west-1:001567907213:table/gregsharpe-tfstate-lock",
    ]
  }
}

resource aws_iam_policy state_access {
  name   = "terraform-state-access"
  policy = data.aws_iam_policy_document.state_access.json
}

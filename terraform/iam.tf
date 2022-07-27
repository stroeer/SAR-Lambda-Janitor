data "aws_region" "current" {}

resource "aws_iam_policy" "lambda" {
  name   = "${local.function_name}-permission-${data.aws_region.current.name}"
  policy = data.aws_iam_policy_document.updater.json
}

resource "aws_iam_role_policy_attachment" "lambda" {
  policy_arn = aws_iam_policy.lambda.arn
  role       = module.lambda.role_name
}

data "aws_iam_policy_document" "updater" {
  statement {
    actions = [
      "lambda:DeleteFunction",
      "lambda:ListAliases",
      "lambda:ListFunctions",
      "lambda:ListVersionsByFunction"
    ]

    resources = ["*"]
  }
}

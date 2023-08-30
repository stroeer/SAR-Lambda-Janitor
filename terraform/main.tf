locals {
  artifact      = "${path.module}/../lambda.zip"
  function_name = "lambda-janitor"
}

module "lambda" {
  source  = "registry.terraform.io/moritzzimmer/lambda/aws"
  version = "6.13.0"

  architectures                     = ["arm64"]
  cloudwatch_logs_retention_in_days = 1
  description                       = "deletes unused Lambda versions"
  filename                          = local.artifact
  function_name                     = local.function_name
  handler                           = "functions/clean.handler"
  runtime                           = "nodejs18.x"
  source_code_hash                  = filebase64sha256(local.artifact)
  timeout                           = 900

  cloudwatch_event_rules = {
    cron = {
      schedule_expression = "cron(0 10 ? * MON-FRI *)"
    }
  }

  environment = {
    variables = {
      VERSIONS_TO_KEEP = 5
    }
  }
}

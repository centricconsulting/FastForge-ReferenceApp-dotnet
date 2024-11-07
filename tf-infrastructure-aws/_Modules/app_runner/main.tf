resource "aws_apprunner_auto_scaling_configuration_version" "this_autoscaling" {
  auto_scaling_configuration_name = "${var.name}_auto_scalling"
  max_concurrency = var.maximum_concurrent_requests
  max_size        = var.max_size
  min_size        = var.min_size

  tags = var.tags
}

resource "aws_apprunner_service" "this" {
  service_name = var.name

  source_configuration {
    image_repository {
      image_configuration {
        port = var.port
      }
      image_identifier      = var.ecr_uri //"public.ecr.aws/aws-containers/hello-app-runner:latest"
      image_repository_type = "ECR"
    }
    auto_deployments_enabled = var.auto_deployments_enabled
  }

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.this_autoscaling.arn

  instance_configuration {
    cpu    = var.cpu_units
    memory = var.memory_in_gb
  }

  tags = var.tags
}

resource "aws_apprunner_vpc_connector" "rds_connector" {
  vpc_connector_name = "${var.name}_rds_connector"
  subnets            = var.rds_subnets
  security_groups    = var.rds_security_groups
}

# data "aws_iam_policy_document" "assume_role_app_runner" {
#   statement {
#     actions = ["sts:AssumeRole"]
#     principals {
#       type        = "Service"
#       identifiers = [
#         "build.apprunner.amazonaws.com",
#         "tasks.apprunner.amazonaws.com"
#       ]
#     }
#   }
# }

# resource "aws_iam_role" "role" {
#   name               = "${var.name}_app_runner_ecr_role"
#   assume_role_policy = data.aws_iam_policy_document.assume_role_app_runner.json
# }

# resource "aws_iam_role_policy_attachment" "ecr_policy_attach" {
#    role       = aws_iam_role.role.name
#    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
# }
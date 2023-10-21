resource "aws_ecs_cluster" "app" {
  name = "app"
}

# Log groups hold logs from our app.
resource "aws_cloudwatch_log_group" "_api" {
  name = "/ecs/reference-app-api"
}

# The main service.
resource "aws_ecs_service" "reference_app_api" {
  name            = "reference-app-api"
  task_definition = aws_ecs_task_definition.reference_app_api.arn
  cluster         = aws_ecs_cluster.app.id
  launch_type     = "FARGATE"

  desired_count = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.reference_app_api.arn
    container_name   = "reference-app-api"
    container_port   = tostring(var.container_port)
  }

  network_configuration {
    assign_public_ip = false

    security_groups = [
      aws_security_group.egress_all.id,
      aws_security_group.ingress_api.id,
    ]

    subnets = [
      aws_subnet.private_d.id,
      aws_subnet.private_e.id,
    ]
  }
}

# The task definition for our app.
resource "aws_ecs_task_definition" "reference_app_api" {
  family = "reference-app-api"

  container_definitions = <<EOF
  [
    {
      "name": "reference-app-api",
      "image": "${var.container_registry_url}:latest",
      "portMappings": [
        {
          "containerPort": ${var.container_port}
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-region": "${data.aws_region.current.id}",
          "awslogs-group": "/ecs/reference-app-api",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]

EOF

  execution_role_arn = aws_iam_role.reference_app_api_task_execution_role.arn

  # These are the minimum values for Fargate containers.
  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["FARGATE"]

  # This is required for Fargate containers (more on this later).
  network_mode = "awsvpc"
}

# This is the role under which ECS will execute our task. This role becomes more important
# as we add integrations with other AWS services later on.

# The assume_role_policy field works with the following aws_iam_policy_document to allow
# ECS tasks to assume this role we're creating.
resource "aws_iam_role" "reference_app_api_task_execution_role" {
  name               = "reference-app-api-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Normally we'd prefer not to hardcode an ARN in our Terraform, but since this is an AWS-managed
# policy, it's okay.
data "aws_iam_policy" "ecs_task_execution_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Attach the above policy to the execution role.
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.reference_app_api_task_execution_role.name
  policy_arn = data.aws_iam_policy.ecs_task_execution_role.arn
}

resource "aws_lb_target_group" "reference_app_api" {
  name        = "reference-app-api"
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.app_vpc.id

  health_check {
    enabled = true
    path    = "/health"
  }

  depends_on = [aws_alb.reference_app_api]
}

resource "aws_alb" "reference_app_api" {
  name               = "reference-app-api-lb"
  internal           = false
  load_balancer_type = "application"

  subnets = [
    aws_subnet.public_d.id,
    aws_subnet.public_e.id,
  ]

  security_groups = [
    aws_security_group.http.id,
    aws_security_group.https.id,
    aws_security_group.egress_all.id,
  ]

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_alb_listener" "reference_app_api_http" {
  load_balancer_arn = aws_alb.reference_app_api.arn
  port              = "80"
  protocol          = "HTTP"

#   default_action {
#     type = "redirect"

#     redirect {
#       port        = "443"
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.reference_app_api.arn
  }
}

# resource "aws_alb_listener" "reference_app_api_https" {
#   load_balancer_arn = aws_alb.reference_app_api.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   certificate_arn   = aws_acm_certificate.reference_app_api.arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.reference_app_api.arn
#   }
# }

# output "alb_url" {
#   value = "http://${aws_alb.reference_app_api.dns_name}"
# }

# resource "aws_acm_certificate" "reference_app_api" {
#   domain_name       = "sun-api.jimmysawczuk.net"
#   validation_method = "DNS"
# }

# output "domain_validations" {
#   value = aws_acm_certificate.reference_app_api.domain_validation_options
# }
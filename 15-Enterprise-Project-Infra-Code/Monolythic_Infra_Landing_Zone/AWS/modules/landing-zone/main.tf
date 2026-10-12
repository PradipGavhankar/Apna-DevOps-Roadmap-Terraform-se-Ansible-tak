locals {
  name_prefix = "${var.project_name}-${var.environment}"
  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
  })

  available_azs = length(var.availability_zones) > 0 ? var.availability_zones : data.aws_availability_zones.available.names
  azs           = slice(local.available_azs, 0, 2)
  nat_azs       = var.nat_gateway_mode == "single" ? [local.azs[0]] : local.azs

  subnet_tiers = {
    ingress     = var.subnet_cidrs.ingress
    application = var.subnet_cidrs.application
    database    = var.subnet_cidrs.database
    management  = var.subnet_cidrs.management
  }
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-vpc"
  })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-igw"
  })
}

resource "aws_subnet" "tier" {
  for_each = {
    for item in flatten([
      for tier, cidrs in local.subnet_tiers : [
        for index, cidr in cidrs : {
          key    = "${tier}-${index + 1}"
          tier   = tier
          cidr   = cidr
          az     = local.azs[index]
          public = tier == "ingress"
        }
      ]
    ]) : item.key => item
  }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.public

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-${each.value.tier}-${each.value.az}"
    Tier = each.value.tier
  })
}

resource "aws_route_table" "ingress" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-ingress-rt"
  })
}

resource "aws_route" "ingress_default" {
  route_table_id         = aws_route_table.ingress.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "ingress" {
  for_each = { for index, az in local.azs : az => index }

  subnet_id      = aws_subnet.tier["ingress-${each.value + 1}"].id
  route_table_id = aws_route_table.ingress.id
}

resource "aws_eip" "nat" {
  for_each = toset(local.nat_azs)

  domain = "vpc"

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-nat-eip-${each.key}"
  })
}

resource "aws_nat_gateway" "main" {
  for_each = toset(local.nat_azs)

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.tier["ingress-${index(local.azs, each.key) + 1}"].id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-nat-${each.key}"
  })

  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "application" {
  for_each = toset(local.azs)

  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-application-rt-${each.key}"
  })
}

resource "aws_route" "application_default" {
  for_each = toset(local.azs)

  route_table_id         = aws_route_table.application[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[var.nat_gateway_mode == "single" ? local.nat_azs[0] : each.key].id
}

resource "aws_route_table_association" "application" {
  for_each = { for index, az in local.azs : az => index }

  subnet_id      = aws_subnet.tier["application-${each.value + 1}"].id
  route_table_id = aws_route_table.application[each.key].id
}

# Database and management subnets intentionally retain only the VPC-local route.
resource "aws_route_table" "isolated" {
  for_each = toset(["database", "management"])

  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-${each.key}-isolated-rt"
  })
}

resource "aws_route_table_association" "isolated" {
  for_each = {
    for item in flatten([
      for tier in ["database", "management"] : [
        for index, az in local.azs : {
          key   = "${tier}-${index + 1}"
          tier  = tier
          index = index
          az    = az
        }
      ]
    ]) : item.key => item
  }

  subnet_id      = aws_subnet.tier[each.key].id
  route_table_id = aws_route_table.isolated[each.value.tier].id
}

resource "aws_security_group" "load_balancer" {
  name        = "${local.name_prefix}-alb"
  description = "Public HTTPS ingress; backend-only egress."
  vpc_id      = aws_vpc.main.id
  egress      = []

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-alb-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.load_balancer.id
  description       = "HTTP, redirected to HTTPS."
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.load_balancer.id
  description       = "Internet HTTPS ingress."
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_security_group" "application" {
  name        = "${local.name_prefix}-application"
  description = "Private HTTP backend; accepts traffic only from the ALB."
  vpc_id      = aws_vpc.main.id
  egress      = []

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-application-sg"
  })
}

resource "aws_vpc_security_group_egress_rule" "alb_to_application" {
  security_group_id            = aws_security_group.load_balancer.id
  description                  = "Forward application HTTP to the private target group."
  referenced_security_group_id = aws_security_group.application.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

resource "aws_vpc_security_group_ingress_rule" "application_from_alb" {
  security_group_id            = aws_security_group.application.id
  description                  = "Only the ALB may reach nginx."
  referenced_security_group_id = aws_security_group.load_balancer.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

resource "aws_vpc_security_group_egress_rule" "application_https" {
  security_group_id = aws_security_group.application.id
  description       = "HTTPS-only outbound for package repositories, SSM, and monitoring APIs."
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_kms_key" "logs" {
  description             = "Encryption key for ${local.name_prefix} diagnostic logs."
  deletion_window_in_days = 30
  enable_key_rotation     = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EnableAccountAdministration"
        Effect = "Allow"
        Principal = {
          AWS = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "AllowCloudWatchLogsUse"
        Effect = "Allow"
        Principal = {
          Service = "logs.${var.aws_region}.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
        Condition = {
          ArnLike = {
            "kms:EncryptionContext:aws:logs:arn" = "arn:${data.aws_partition.current.partition}:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*"
          }
        }
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-logs-kms"
  })
}

resource "aws_kms_alias" "logs" {
  name          = "alias/${local.name_prefix}-logs"
  target_key_id = aws_kms_key.logs.key_id
}

resource "aws_secretsmanager_secret" "application" {
  name                    = "${local.name_prefix}/application"
  description             = "Empty application secret container; provision secret versions through an approved secret-delivery workflow."
  kms_key_id              = aws_kms_key.logs.arn
  recovery_window_in_days = 30

  tags = local.common_tags
}

resource "aws_s3_bucket" "logs" {
  bucket        = "${substr(replace(local.name_prefix, "-", ""), 0, 16)}-logs-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.region}"
  force_destroy = false

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-diagnostic-logs"
  })
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket                  = aws_s3_bucket.logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.logs.arn
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_policy" "logs" {
  bucket = aws_s3_bucket.logs.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "DenyInsecureTransport"
      Effect    = "Deny"
      Principal = "*"
      Action    = "s3:*"
      Resource = [
        aws_s3_bucket.logs.arn,
        "${aws_s3_bucket.logs.arn}/*"
      ]
      Condition = {
        Bool = {
          "aws:SecureTransport" = "false"
        }
      }
    }]
  })
}

resource "aws_cloudwatch_log_group" "waf" {
  name              = "aws-waf-logs-${local.name_prefix}"
  retention_in_days = 30
  kms_key_id        = aws_kms_key.logs.arn

  tags = local.common_tags
}

resource "aws_cloudwatch_log_resource_policy" "waf" {
  policy_name = "${local.name_prefix}-waf-log-delivery"
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "delivery.logs.amazonaws.com"
      }
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = "${aws_cloudwatch_log_group.waf.arn}:*"
    }]
  })
}

resource "aws_cloudwatch_log_group" "application" {
  name              = "/${local.name_prefix}/application/nginx"
  retention_in_days = 30
  kms_key_id        = aws_kms_key.logs.arn

  tags = local.common_tags
}

resource "aws_cloudwatch_log_group" "vpc_flow" {
  name              = "/${local.name_prefix}/vpc/flow"
  retention_in_days = 90
  kms_key_id        = aws_kms_key.logs.arn

  tags = local.common_tags
}

resource "aws_iam_role" "vpc_flow_logs" {
  name = "${local.name_prefix}-vpc-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "vpc-flow-logs.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy" "vpc_flow_logs" {
  name = "${local.name_prefix}-vpc-flow-logs"
  role = aws_iam_role.vpc_flow_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ]
      Resource = [
        aws_cloudwatch_log_group.vpc_flow.arn,
        "${aws_cloudwatch_log_group.vpc_flow.arn}:*"
      ]
    }]
  })
}

resource "aws_flow_log" "vpc" {
  vpc_id               = aws_vpc.main.id
  traffic_type         = "ALL"
  log_destination_type = "cloud-watch-logs"
  log_destination      = aws_cloudwatch_log_group.vpc_flow.arn
  iam_role_arn         = aws_iam_role.vpc_flow_logs.arn

  depends_on = [aws_iam_role_policy.vpc_flow_logs]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-vpc-flow"
  })
}

resource "aws_iam_role" "application" {
  name = "${local.name_prefix}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.application.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "application_logs" {
  name = "${local.name_prefix}-application-logs"
  role = aws_iam_role.application.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ]
      Resource = "${aws_cloudwatch_log_group.application.arn}:*"
    }]
  })
}

resource "aws_iam_instance_profile" "application" {
  name = "${local.name_prefix}-ec2-profile"
  role = aws_iam_role.application.name

  tags = local.common_tags
}

resource "aws_lb" "application" {
  name                       = substr("${local.name_prefix}-alb", 0, 32)
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.load_balancer.id]
  subnets                    = [for index in range(2) : aws_subnet.tier["ingress-${index + 1}"].id]
  ip_address_type            = "ipv4"
  enable_deletion_protection = var.environment == "prod"
  drop_invalid_header_fields = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-alb"
  })
}

resource "aws_wafv2_web_acl" "application" {
  name        = "${local.name_prefix}-web-acl"
  description = "Regional AWS managed common protections for the public application ALB."
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${local.name_prefix}-common-rules"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${local.name_prefix}-web-acl"
    sampled_requests_enabled   = true
  }

  tags = local.common_tags
}

resource "aws_wafv2_web_acl_association" "application" {
  resource_arn = aws_lb.application.arn
  web_acl_arn  = aws_wafv2_web_acl.application.arn
}

resource "aws_wafv2_web_acl_logging_configuration" "application" {
  resource_arn            = aws_wafv2_web_acl.application.arn
  log_destination_configs = [aws_cloudwatch_log_group.waf.arn]

  depends_on = [aws_cloudwatch_log_resource_policy.waf]

  redacted_fields {
    single_header {
      name = "authorization"
    }
  }
}

resource "aws_lb_target_group" "application" {
  name                 = substr("${local.name_prefix}-app-tg", 0, 32)
  port                 = 80
  protocol             = "HTTP"
  target_type          = "instance"
  vpc_id               = aws_vpc.main.id
  deregistration_delay = 30

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 30
    timeout             = 5
    path                = "/"
    matcher             = "200-399"
    protocol            = "HTTP"
  }

  tags = local.common_tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.application.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.application.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application.arn
  }
}

resource "aws_launch_template" "application" {
  name_prefix            = "${local.name_prefix}-app-"
  image_id               = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type          = var.instance_type
  update_default_version = true
  user_data = base64encode(templatefile("${path.module}/user_data.sh.tftpl", {
    region         = var.aws_region
    log_group_name = aws_cloudwatch_log_group.application.name
    project_name   = var.project_name
    environment    = var.environment
  }))

  iam_instance_profile {
    name = aws_iam_instance_profile.application.name
  }

  monitoring {
    enabled = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "disabled"
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.application.id]
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(local.common_tags, {
      Name = "${local.name_prefix}-application"
    })
  }

  tag_specifications {
    resource_type = "volume"
    tags          = local.common_tags
  }

  tags = local.common_tags
}

resource "aws_autoscaling_group" "application" {
  name                      = "${local.name_prefix}-application-asg"
  min_size                  = var.asg_min_size
  desired_capacity          = var.asg_desired_capacity
  max_size                  = var.asg_max_size
  vpc_zone_identifier       = [for index in range(2) : aws_subnet.tier["application-${index + 1}"].id]
  target_group_arns         = [aws_lb_target_group.application.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 180
  default_instance_warmup   = 180
  force_delete              = false

  launch_template {
    id      = aws_launch_template.application.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 50
      instance_warmup        = 180
    }
  }

  dynamic "tag" {
    for_each = local.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  tag {
    key                 = "Name"
    value               = "${local.name_prefix}-application"
    propagate_at_launch = true
  }
}

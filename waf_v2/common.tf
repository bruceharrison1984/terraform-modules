## These represent rule sets that Amazon makes available for freename
## Each rule set has a WCU value, and cumulativly they cannot exceed 1500 for a single ACL

locals {
  aws_managed_rule_sets = {
    AWSManagedRulesAmazonIpReputationList = {
      priority      = 0
      excludedRules = []
    },
    AWSManagedRulesCommonRuleSet = {
      priority      = 1
      excludedRules = ["NoUserAgent_HEADER", "SizeRestrictions_QUERYSTRING"]
    },
    AWSManagedRulesBotControlRuleSet = {
      priority      = 2
      excludedRules = ["SignalNonBrowserUserAgent"]
    },
    AWSManagedRulesKnownBadInputsRuleSet = {
      priority      = 3
      excludedRules = []
    },
    AWSManagedRulesSQLiRuleSet = {
      priority      = 4
      excludedRules = []
    },
    AWSManagedRulesLinuxRuleSet = {
      priority      = 5
      excludedRules = []
    },
  }
}

resource "aws_wafv2_web_acl" "common" {
  name        = "${var.name_prefix}-common-acl"
  description = "Block common attack vectors. Rules defined by AWS."
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  dynamic "rule" {
    iterator = ruleset
    for_each = local.aws_managed_rule_sets
    content {
      name     = "${var.name_prefix}-${ruleset.key}"
      priority = ruleset.value.priority

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = ruleset.key
          vendor_name = "AWS"

          dynamic "excluded_rule" {
            for_each = ruleset.value.excludedRules
            iterator = excludedRule
            content {
              name = excludedRule.value
            }
          }
        }
      }
      ## metrics for individual rule
      visibility_config {
        cloudwatch_metrics_enabled = var.enable_cloudwatch_metrics
        metric_name                = "${var.name_prefix}-${ruleset.key}-rule"
        sampled_requests_enabled   = var.enable_sampling_requests
      }
    }
  }

  rule {
    name     = "${var.name_prefix}-rate-limit"
    priority = length(local.aws_managed_rule_sets)

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = var.ip_rate_limit
        aggregate_key_type = "IP"
        scope_down_statement {
          not_statement {
            statement {
              byte_match_statement {
                field_to_match {
                  single_header {
                    name = "user-agent"
                  }
                }
                positional_constraint = "EXACTLY"
                search_string         = "k6 cloud (https://k6.io/)"
                text_transformation {
                  type     = "NONE"
                  priority = 0
                }
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = var.enable_cloudwatch_metrics
      metric_name                = "${var.name_prefix}-rate-limit"
      sampled_requests_enabled   = var.enable_sampling_requests
    }
  }
  
  rule {
    name      = "${var.name_prefix}-block-metrics-endpoint"
    priority  = length(local.aws_managed_rule_sets) + 1
    
    action {
      block {
        custom_response {
          response_code = "404"
        } ##custom_response
      }## block
    } ## action
    
    visibility_config {
      sampled_requests_enabled    = var.enable_sampling_requests
      cloudwatch_metrics_enabled  = var.enable_cloudwatch_metrics
      metric_name                 = "${var.name_prefix}-block-metrics-endpoint"
    }
    
    statement {
      byte_match_statement {
        field_to_match {
          uri_path {}
        } ##field_to_match
        positional_constraint = "CONTAINS"
        search_string         = "metrics"
        text_transformation {
            type      = "LOWERCASE"
            priority  = 0
        } ##text_transformations
      }##byte_match_statement
    }##statement
  }##rule

  visibility_config {
    cloudwatch_metrics_enabled = var.enable_cloudwatch_metrics
    metric_name                = "${var.name_prefix}-common-acl"
    sampled_requests_enabled   = var.enable_sampling_requests
  }
}

resource "aws_wafv2_web_acl_association" "common" {
  count        = length(var.alb_arns)
  resource_arn = var.alb_arns[count.index]
  web_acl_arn  = aws_wafv2_web_acl.common.arn
}

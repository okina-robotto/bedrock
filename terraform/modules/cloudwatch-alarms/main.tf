data "aws_caller_identity" "main" {}

resource "aws_sns_topic" "main" {
  name_prefix = "${var.stack}-${var.environment}-${var.name}-threshold-alerts-"
}

resource "aws_sns_topic_policy" "main" {
  arn    = aws_sns_topic.main.arn
  policy = "${data.aws_iam_policy_document.main.json}"
}

data "aws_iam_policy_document" "main" {
  policy_id = "__default_policy_ID"

  statement {
    sid = "__default_statement_ID"

    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    effect    = "Allow"
    resources = ["${aws_sns_topic.main.arn}"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        "arn:aws:iam::${var.aws_account_id}:root",
      ]
    }
  }

  statement {
    sid       = "Allow SNS CloudwatchEvents"
    actions   = ["sns:Publish"]
    resources = ["${aws_sns_topic.main.arn}"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = "${aws_cloudwatch_metric_alarm.default.*.arn}"
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  alert_for     = "CloudTrailBreach"
  sns_topic_arn = aws_sns_topic.main.arn
  endpoints     = aws_sns_topic.main.id
  region        = data.aws_region.current.name

  metric_name = [
    "AuthorizationFailureCount",
    "S3BucketActivityEventCount",
    "SecurityGroupEventCount",
    "NetworkAclEventCount",
    "GatewayEventCount",
    "VpcEventCount",
    "CloudTrailEventCount",
    "ConsoleSignInFailureCount",
    "IAMPolicyEventCount",
    "ConsoleSignInWithoutMfaCount",
    "RootAccountUsageCount",
    "KMSKeyPendingDeletionErrorCount",
    "AWSConfigChangeCount",
    "RouteTableChangesCount",
  ]

  metric_namespace = "CISBenchmark"
  metric_value     = "1"

  filter_pattern = [
    "{ ($.errorCode = \"*UnauthorizedOperation\") || ($.errorCode = \"AccessDenied*\") }",
    "{ ($.eventSource = s3.amazonaws.com) && (($.eventName = PutBucketAcl) || ($.eventName = PutBucketPolicy) || ($.eventName = PutBucketCors) || ($.eventName = PutBucketLifecycle) || ($.eventName = PutBucketReplication) || ($.eventName = DeleteBucketPolicy) || ($.eventName = DeleteBucketCors) || ($.eventName = DeleteBucketLifecycle) || ($.eventName = DeleteBucketReplication)) }",
    "{ ($.eventName = AuthorizeSecurityGroupIngress) || ($.eventName = AuthorizeSecurityGroupEgress) || ($.eventName = RevokeSecurityGroupIngress) || ($.eventName = RevokeSecurityGroupEgress) || ($.eventName = CreateSecurityGroup) || ($.eventName = DeleteSecurityGroup) }",
    "{ ($.eventName = CreateNetworkAcl) || ($.eventName = CreateNetworkAclEntry) || ($.eventName = DeleteNetworkAcl) || ($.eventName = DeleteNetworkAclEntry) || ($.eventName = ReplaceNetworkAclEntry) || ($.eventName = ReplaceNetworkAclAssociation) }",
    "{ ($.eventName = CreateCustomerGateway) || ($.eventName = DeleteCustomerGateway) || ($.eventName = AttachInternetGateway) || ($.eventName = CreateInternetGateway) || ($.eventName = DeleteInternetGateway) || ($.eventName = DetachInternetGateway) }",
    "{ ($.eventName = CreateVpc) || ($.eventName = DeleteVpc) || ($.eventName = ModifyVpcAttribute) || ($.eventName = AcceptVpcPeeringConnection) || ($.eventName = CreateVpcPeeringConnection) || ($.eventName = DeleteVpcPeeringConnection) || ($.eventName = RejectVpcPeeringConnection) || ($.eventName = AttachClassicLinkVpc) || ($.eventName = DetachClassicLinkVpc) || ($.eventName = DisableVpcClassicLink) || ($.eventName = EnableVpcClassicLink) }",
    "{ ($.eventName = CreateTrail) || ($.eventName = UpdateTrail) || ($.eventName = DeleteTrail) || ($.eventName = StartLogging) || ($.eventName = StopLogging) }",
    "{ ($.eventName = ConsoleLogin) && ($.errorMessage = \"Failed authentication\") }",
    "{ ($.eventName = DeleteGroupPolicy) || ($.eventName = DeleteRolePolicy) ||($.eventName=DeleteUserPolicy)||($.eventName=PutGroupPolicy)||($.eventName=PutRolePolicy)||($.eventName=PutUserPolicy)||($.eventName=CreatePolicy)||($.eventName=DeletePolicy)||($.eventName=CreatePolicyVersion)||($.eventName=DeletePolicyVersion)||($.eventName=AttachRolePolicy)||($.eventName=DetachRolePolicy)||($.eventName=AttachUserPolicy)||($.eventName=DetachUserPolicy)||($.eventName=AttachGroupPolicy)||($.eventName=DetachGroupPolicy)}",
    "{ ($.eventName = \"ConsoleLogin\") && ($.additionalEventData.MFAUsed != \"Yes\") }",
    "{ $.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\" }",
    "{($.eventSource = kms.amazonaws.com) && (($.eventName=DisableKey)||($.eventName=ScheduleKeyDeletion))}",
    "{($.eventSource = config.amazonaws.com) && (($.eventName=StopConfigurationRecorder)||($.eventName=DeleteDeliveryChannel)||($.eventName=PutDeliveryChannel)||($.eventName=PutConfigurationRecorder))}",
    "{ ($.eventName = CreateRoute) || ($.eventName = CreateRouteTable) || ($.eventName = ReplaceRoute) || ($.eventName = ReplaceRouteTableAssociation) || ($.eventName = DeleteRouteTable) || ($.eventName = DeleteRoute) || ($.eventName = DisassociateRouteTable) }",
  ]

  alarm_description = [
    "Alarms when an unauthorized API call is made.",
    "Alarms when an API call is made to S3 to put or delete a Bucket, Bucket Policy or Bucket ACL.",
    "Alarms when an API call is made to create, update or delete a Security Group.",
    "Alarms when an API call is made to create, update or delete a Network ACL.",
    "Alarms when an API call is made to create, update or delete a Customer or Internet Gateway.",
    "Alarms when an API call is made to create, update or delete a VPC, VPC peering connection or VPC connection to classic.",
    "Alarms when an API call is made to create, update or delete a .cloudtrail. trail, or to start or stop logging to a trail.",
    "Alarms when an unauthenticated API call is made to sign into the console.",
    "Alarms when an API call is made to change an IAM policy.",
    "Alarms when a user logs into the console without MFA.",
    "Alarms when a root account usage is detected.",
    "Alarms when a customer created KMS key is pending deletion.",
    "Alarms when AWS Config changes.",
    "Alarms when route table changes are detected.",
  ]
}

resource "aws_cloudwatch_log_metric_filter" "default" {
  count          = "${length(local.filter_pattern)}"
  name           = "${local.metric_name[count.index]}-filter"
  pattern        = "${local.filter_pattern[count.index]}"
  log_group_name = "/cloudtrail/${var.stack}-${var.environment}-${var.name}"

  metric_transformation {
    name      = "${local.metric_name[count.index]}"
    namespace = "${local.metric_namespace}"
    value     = "${local.metric_value}"
  }
}

resource "aws_cloudwatch_metric_alarm" "default" {
  count               = "${length(local.filter_pattern)}"
  alarm_name          = "${local.metric_name[count.index]}-alarm-${var.stack}-${var.environment}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "${local.metric_name[count.index]}"
  namespace           = "${local.metric_namespace}"
  period              = "300"                                                                         // 5 min
  statistic           = "Sum"
  treat_missing_data  = "notBreaching"
  threshold           = "${local.metric_name[count.index] == "ConsoleSignInFailureCount" ? "3" :"1"}"
  alarm_description   = "${local.alarm_description[count.index]}"
  alarm_actions       = ["${local.endpoints}"]
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "Combined"

  dashboard_body = <<EOF
 {
   "widgets": [
       {
          "type":"metric",
          "x":0,
          "y":0,
          "width":20,
          "height":16,
          "properties":{
             "metrics":[
               ${join(",",formatlist("[ \"${local.metric_namespace}\", \"%v\" ]", local.metric_name))}
             ],
             "period":300,
             "stat":"Sum",
             "region":"${local.region}",
             "title":"CISBenchmark Statistics"
          }
       }
   ]
 }
 EOF
}

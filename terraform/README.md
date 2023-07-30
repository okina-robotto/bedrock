# Terraform

These templates form the building blocks of BigRobot services, on AWS (with Terraform).

For further Terraform documentation, please see [here](https://developer.hashicorp.com/bedrock/terraform/docs).

## Prerequisites

- [Terraform](https://developer.hashicorp.com/bedrock/terraform/cli)
- [AWS CLI](https://aws.amazon.com/cli)

## Modules

- [acm] - Amazon Certificate Manager module
- [alb] - Application Load Balancer module
- [aurora-cluster] - Aurora Cluster module
- [bastion] - Bastion module
- [cloudtrail] - CloudTrail Module
- [cloudfront] - CloudFront CDN module
- [cloudwatch] - CloudWatch module
- [cloudwatch-alarms] - CloudWatch Alarms module
- [dynamodb] - DynamoDB module
- [common] - Common module with any global settings shared across stacks/environments
- [ecs-cluster] - Elastic Container Service module
- [ecs-cluster-fargate] - Elastic Container Service module (Fargate)
- [elasticache] - Elasticache module
- [kms] - KMS module
- [lambda] - Lambda module
- [role] - IAM module
- [route53] - Route53 (domain) module
- [route53-record] Route53 (DNS records) module
- [s3] - S3 Module
- [service] - ECS Service module
- [service-fargate] - ECS Service module (Fargate)
- [sqs] - SQS Module 
- [task] - ECS Service Task module
- [task-fargate] - ECS Service Task module (Fargate)
- [vpc] - Virtual Private Cloud module

[web]: <https://github.com/okina-robotto/bedrock/terraform/tree/main/stacks/web>
[ecr]: <https://github.com/okina-robotto/bedrock/terraform/tree/main/stacks/ecr>
[acm]: <https://github.com/okina-robotto/bedrock/terraform/tree/main/modules/acm>
[alb]: <https://github.com/okina-robotto/bedrock/terraform/tree/main/modules/alb>
[aurora-cluster]: <https://github.com/okina-robotto/bedrock/terraform/tree/main/modules/aurora-cluster>
[bastion]: <https://github.com/okina-robotto/bedrock/terraform/tree/main/modules/bastion>
[cloudtrail]: <https://github.com/okina-robotto/bedrock/terraform/tree/main/modules/cloudtrail>
[cloudfront]: <https://github.com/okina-robotto/bedrock/terraform/tree/main/modules/cloudfront>
[cloudwatch]: <https://github.com/okina-robotto/bedrock/terraform/tree/main/modules/cloudwatch>
[cloudwatch-alarms]: <https://github.com/okina-robotto/bedrock/terraform/tree/main/modules/cloudwatch-alarms>
[dynamodb]: <https://github.com/okina-robotto/bedrock/terraform/tree/main/modules/dynamodb>
[common]: <https://github.com/okina-robotto/bedrock/terraform/tree/main/modules/common>
[ecs-cluster]: <https://github.com/okina-robotto/bedrock/terraform/tree/main/modules/ecs-cluster>
[ecs-cluster-fargate]: <https://github.com/okina-robotto/bedrock/terraform/tree/main/modules/ecs-cluster-fargate>
[elasticache]: <https://github.com/okina-robotto/bedrock/terraform/tree/main/modules/elasticache>
[kms]: <https://github.com/okina-robotto/bedrock/terraform/tree/main/modules/kms>
[lambda]: <https://github.com/okina-robotto/bedrock/terraform/tree/main/modules/lambda>
[role]: <https://github.com/okina-robotto/bedrock/terraform/tree/main/modules/role>
[route53]: <https://github.com/okina-robotto/bedrock/terraform/tree/main/modules/route53>
[route53-record]: <https://github.com/okina-robotto/bedrock/terraform/tree/main/modules/route53-record>
[s3]: <https://github.com/okina-robotto/bedrock/terraform/tree/main/modules/s3>
[service]: <https://github.com/okina-robotto/bedrock/terraform/tree/main/modules/service>
[service-fargate]: <https://github.com/okina-robotto/bedrock/terraform/tree/main/modules/service-fargate>
[sqs]: <https://github.com/okina-robotto/bedrock/terraform/tree/main/modules/sqs>
[task]: <https://github.com/okina-robotto/bedrock/terraform/tree/main/modules/task>
[task-fargate]: <https://github.com/okina-robotto/bedrock/terraform/tree/main/modules/task-fargate>
[vpc]: <https://github.com/okina-robotto/bedrock/terraform/tree/main/modules/vpc>

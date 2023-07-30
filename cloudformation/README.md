# Cloudformation

These templates form the building blocks of BigRobot services, on AWS (with CloudFormation).

For further Cloudformation documentation, please see [here](https://docs.aws.amazon.com/cloudformation/index.html).

## Prerequisites

- [AWS CLI](https://aws.amazon.com/cli)

## Sync

Whenever you make a change to a template, please remember to perform a sync:

```
aws s3 sync . s3://<bucket> --exclude "*" --include "*.yml"
```

where `<bucket>` is the name of the S3 bucket to sync to.

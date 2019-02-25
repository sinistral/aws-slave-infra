## AWS Organization slave bootstrap

CloudFormation templates to bootstrap an account as a subordinate in an [AWS
Organization][awsorg], under a [suitably bootstrapped master][master].

Features:

* A trust relationship with the master account, which allows the master to
  provide centralised policy and user management for all subordinate accounts
  in the organisation.  The ID of the master account must be set up once, by
  hand, in the [Parameter Store][paramstore]; by default the parameter key is
  `/bootstrap/master-account-id`, but may be overridden using a stack
  parameter.

* A minimal set of resources is deployed to support the
  Code{Pipeline,Build}-based deployment of [applications][apptemplate] into the
  account.

## Usage

First deployment:
```
  make bootstrap-stack
```
Subsequent changes may be applied via [change sets][changeset] using:
```
  make bootstrap-stack-update-change-set
```

## License

Published under the [2-clause BSD license][license]

[awsorgs]: https://aws.amazon.com/organizations
[master]: https://github.com/sinistral/aws-master-infra
[paramstore]: https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-paramstore.html
[apptemplate]: https://github.com/sinistral/aws-serverless-application-template
[changeset]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-updating-stacks-changesets.html

[license]: https://opensource.org/licenses/BSD-2-Clause

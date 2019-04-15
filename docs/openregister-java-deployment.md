# openregister-java deployment process

## Deploying
* Merge to `master`
*Tests and building of JAR takes place in Travis-CI*
* Build is automatically deployed to `test` environment e.g. https://country.test.openregister.org/
* To promote the build on `test` to the production environment [Login to AWS CodePipeline](https://eu-west-1.console.aws.amazon.com/codesuite/codepipeline/pipelines/openregister-java/view?region=eu-west-1)
* Click _Review_, type a message and click _Approve_

### Changing the Deployment configuration
The CodePipeline configuration is terraformed: https://github.com/openregister/deployment/tree/master/aws/pipeline


## Deployment Notifications
Deployment notifications are sent to Slack using a webhook integration.

### Changing the Notification configuration
The architecture of the notifier is:
```
CodePipeline --> CloudWatch Logs --> CloudWatch Rules --> SNS --> Lambda --> Slack
```
Note: The notification architecture is not currently Terraformed. The Lambda is `deployment_to_slack` in `eu-west-1`.


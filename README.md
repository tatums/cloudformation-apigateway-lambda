## Cloudformation ApiGateway and Lambda

An simple example using cloudformation to build an ApiGatway with
Lambda. This relies on the (AWS CLI)[https://aws.amazon.com/cli/].
There is a shell script to orchestrate the deploy.


#### Create the stack

```bash
$ aws cloudformation create-stack --stack-name hello-world --template-body file://./cloudformation.json --capabilities CAPABILITY_IAM --profile=personal && aws cloudformation wait stack-create-complete --stack-name hello-world --profile=personal
```

## Update the stack
```bash
$ aws cloudformation update-stack --stack-name hello-world --template-body file://./cloudformation.json --capabilities CAPABILITY_IAM --profile=personal && aws cloudformation wait stack-update-complete --stack-name hello-world --profile=personal
```

## Delete the stack
```bash
$ aws cloudformation delete-stack --stack-name hello-world --profile=personal && aws cloudformation wait stack-delete-complete --stack-name hello-world --profile=personal
```

## Get the rest-api-id
```
$ aws apigateway get-rest-apis --profile personal
```

## deploy
Pass the rest-api-id to the deploy script
```
./deploy.sh grvuckjf24
```

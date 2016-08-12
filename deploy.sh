#!/bin/bash

apiId=$1
functionName=$2
profile=personal

YELLOW='\033[0;33m'
WHITE='\033[0m' # No Color

function zipLambda {
  say "Zipping files." && \
  rm -rf target && \
  mkdir -p target && \
  cp -r *.js package.json target/ && \
  pushd target && \
  npm install --production && \
  zip -r "${functionName}.zip" . && \
  popd
}

function say {
  printf "\n${YELLOW} $@ ${WHITE}\n"
}

function updateLambdaCode {
  say "Uploading new lambda code." && \
  aws lambda update-function-code --function-name $functionName --zip-file "fileb://target/${functionName}.zip" --profile $profile
}

function publishVersion {
  say "Publishing a new version." && \
  aws lambda publish-version --function-name $functionName --profile $profile
}

function updateAlias {
  version=$(aws lambda list-versions-by-function --function-name $functionName --profile personal | grep Version | tail -n 1 | cut -d '"' -f 4) && \
  say "Updating the alias to version ${version}." && \
  aws lambda update-alias --function-name $functionName --function-version $version --name prod --profile $profile
}

function deployApiGatway {
  say "Deploying to Api Gateway." && \
  aws apigateway create-deployment --rest-api-id $apiId --stage-name v1 --profile $profile
}

printf "\n🚀🚀🚀 SHIP IT!!! 🚀🚀🚀 \n\n"

zipLambda && \
  updateLambdaCode && \
  publishVersion && \
  updateAlias && \
  deployApiGatway

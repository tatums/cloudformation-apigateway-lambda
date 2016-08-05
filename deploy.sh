#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

options=("YES" "NO")

apiId=$1
functionName=hello-world-hello
profile=personal


function zipLambda {
  rm -rf target
  mkdir -p target
  cp -r *.js package.json lib target/
  pushd target
  npm install --production
  zip -r hello-lambda.zip .
  popd
}

function updateLambdaCode {
  aws lambda update-function-code --function-name $functionName --zip-file fileb://target/hello-lambda.zip --profile $profile
}

function publishVersion {
  aws lambda publish-version --function-name $functionName --profile $profile
}

function updateAlias {
  version=$(aws lambda list-versions-by-function --function-name hello-world-hello --profile personal | grep Version | tail -n 1 | cut -d '"' -f 4)
  aws lambda update-alias --function-name $functionName --function-version $version --name prod --profile $profile
}

function deployApiGatway {
  aws apigateway create-deployment --rest-api-id $apiId --stage-name v1 --profile $profile
}

items="
zipLambda
updateLambdaCode
publishVersion
updateAlias
deployApiGatway
"

printf "\n🚀 SHIP IT!!!\n\n"
for item in $items; do
  printf "Do you want to run ${RED}$item${NC}?\n\n"
  read -r -p "Please confirm with [y/N]" response
  case $response in
    [yY][eE][sS]|[yY])
      printf "\nrunning ${GREEN}$item${NC}\n\n"
      $item
      ;;
    *)
      printf "\nskipping ${YELLOW}$item${NC}\n\n"
      ;;
  esac
done

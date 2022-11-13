#!/bin/bash

DEFAULT_REGION=us-east-1

function docker_login() {
    region=${1:-$DEFAULT_REGION}
    account_id=${2}
    account_id=$(aws sts get-caller-identity --query "Account" --output text)
    aws ecr get-login-password --region ${region} \
        | docker login --username AWS --password-stdin ${account_id}.dkr.ecr.${region}.amazonaws.com
}

function main() {
    account_id=$(aws sts get-caller-identity --query "Account" --output text)
    nginx_repo=${1}
    moin_repo=${2}
    region=${3:-$DEFAULT_REGION}

    echo "Docker auth..."
    docker_login ${region} ${account_id}

    nginx_target=${2}
    echo "Build nginx..."
    nginx_target="${account_id}.dkr.ecr.${region}.amazonaws.com/${nginx_repo}:latest"
    docker build --tag ${nginx_target} nginx/

    echo "Push nginx..."
    docker push ${nginx_target}

    echo "Build moin..."
    moin_target="${account_id}.dkr.ecr.${region}.amazonaws.com/${moin_repo}:latest"
    docker build --tag ${moin_target} moin/

    echo "Push moin..."
    docker push ${moin_target}
}

function help() {
    echo "Usage: ${0} NGINX_ECR_REPO MOIN_ECR_REPO [REGION]"
    exit 1
}

if [[ "${1}" == "--help" ]] || [[ "${1}" == "" ]] || [ "{$2}" == "" ]; then
    echo "Invalid usage"
    help
fi

main ${1} ${2} ${3}


## Prerequisites

1. Azure account 
2. Azure subscription
3. GitHub account (using github packages and github actions for deployment)

## Getting Started

1. Bootstrap Terraform 

```bash
sh ./helpers/terraform_bootstrap.sh
```

2. Update the terraform/backend.tf file with the output from step 1

3. Update the env.local.sh file with the output from step 1

4. Set your environment variables

```
source env.local.sh
```


## GitHub Pipeline
Vars - build and push pipeline
- DOCKER_REGISTRY = ghcr.io
- ORGANISATION_NAME = RukayaOK
- DOCKER_IMAGE_NAME
- DOCKER_IMAGE_TAG
- DOCKERFILE_PATH
- BUILD_CONTEXT = "."

ci pipeline
- WORKING_DIRECTORY
- 
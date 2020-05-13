#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
docker run --rm -it \
  -e ARM_CLIENT_ID \
  -e ARM_CLIENT_SECRET \
  -e ARM_SUBSCRIPTION_ID \
  -e ARM_TENANT_ID \
  -v $(pwd):/data \
  --workdir=/data \
  --entrypoint "/bin/sh" \
  hashicorp/terraform:light \
  -c "/bin/terraform init; \
      /bin/terraform get; \
      /bin/terraform validate; \
      /bin/terraform plan -out=out.tfplan; \
      /bin/terraform apply out.tfplan;"
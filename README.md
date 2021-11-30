# terraform-sops-ssm

## Features
- Create SSM secrets from SOPS-encrypted secrets
- Create github-ci+lambda roles and users with access to SSM


## Useful commands
```bash
# show user credentials
$ terraform show -json | jq ".values.outputs.users.value"
```

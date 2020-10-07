# Requirements

- Terraform is installed and in the current $PATH
- Cloudflare API credentials
- AWS access and secret keys.

# Setup

1. Edit variables.tf file.
2. Set the below environment variables:
```
CLOUDFLARE_EMAIL
CLOUDFLARE_API_KEY
```
3. [Install & Configure AWS cli](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) with your credentials
2. Execute `terraform init`
5. Execute `terraform apply`

```hcl

#in main.tf add this backend block

#refer :https://developer.hashicorp.com/terraform/language/backend#partial-configuration

terrafrom{

backend "s3" {
    bucket         = "043902793606-terraform-states"
    key            = "path/to/terraform.tfstate"  # e.g. "envs/prod/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
```

> **NOTE:** you'll need a `config/dev.tfvars` too to set your other environment values.

```bash

env=dev
terraform get -update=true
terraform init -backend-config=config/backend-${env}.conf
terraform plan -var-file=config/${env}.tfvars
terraform apply -var-file=config/${env}.tfvars

```

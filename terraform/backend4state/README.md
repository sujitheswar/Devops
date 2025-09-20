Great 👍 Terraform config that provisions the **remote backend infrastructure** for Terraform itself:

* **S3 bucket** → Stores the Terraform state file.
* **DynamoDB table** → Manages state locking (so multiple people don’t run `terraform apply` at the same time).

---

### 🔎 Walkthrough of Code

#### 1. Terraform version requirement

```hcl
terraform {
  required_version = ">= 0.12"
}
```

* Ensures only Terraform 0.12+ can run this code.

---

#### 2. AWS Provider

```hcl
provider "aws" {}
```

* Uses default AWS credentials (from `~/.aws/credentials` or env vars).
* You can add `region = "us-east-2"` if you want to fix the backend to one region.

---

#### 3. S3 Bucket for State

```hcl
data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "${local.account_id}-terraform-states"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
```

* Bucket name will be globally unique because it prefixes with your AWS **account ID**.
* **Versioning enabled** → history of state changes is kept.
* **SSE (AES256 encryption)** enabled by default.

---

#### 4. DynamoDB Table for Locking

```hcl
resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
```

* Creates a table named `terraform-lock`.
* Uses **on-demand billing** (no capacity planning needed).
* Each lock entry is identified by `"LockID"`.

---

### 🚀 How to Use as a Backend

After applying this config once (so resources exist), you can configure your main `terraform` projects like this:

```hcl
terraform {
  backend "s3" {
    bucket         = "<your-account-id>-terraform-states"
    key            = "myapp/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
```

Then run:

```bash
terraform init -reconfigure
```

---

✅ This setup is **best practice** for team use → state is centralized, versioned, encrypted, and locked.

---


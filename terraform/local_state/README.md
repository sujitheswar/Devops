simple Terraform configuration to launch an **EC2 instance** on AWS.

Here’s a breakdown of what your code is doing:

---

### 📜 Terraform Config Explanation

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}
```

* Ensures Terraform CLI version is **1.2.0 or higher**.
* Pins the AWS provider to **version 4.x** (any version >= 4.16 but < 5.0).

```hcl
provider "aws" {
  region = "us-east-2"
}
```

* Configures AWS provider to use the **Ohio region (us-east-2)**.
* Credentials will be taken from your environment (AWS CLI, IAM role, or shared credentials).

```hcl
resource "aws_instance" "app_server" {
  ami           = "ami-0cfde0ea8edd312d4"
  instance_type = "t3.micro"
  key_name      = "ohio1309"
  subnet_id     = "subnet-078043c28e92411d7"
  associate_public_ip_address = true

  tags = {
    Name = "Terraform_Demo"
  }
}
```

* Launches an **EC2 instance**:

  * **AMI**: `ami-0cfde0ea8edd312d4` (must be valid in `us-east-2`).
  * **Instance type**: `t3.micro` (free-tier eligible).
  * **Key pair**: `ohio1309` (must exist in AWS account).
  * **Subnet**: `subnet-078043c28e92411d7` (must belong to a VPC in us-east-2).
  * **Public IP**: Enabled.
  * **Tag**: `Name = Terraform_Demo`.

---

### 🚀 How to Run This

```bash
# initialize Terraform
terraform init

# see what will be created
terraform plan

# create the resources
terraform apply -auto-approve
```

---

⚠️ **Things to double-check before running**:

1. The AMI ID (`ami-0cfde0ea8edd312d4`) actually exists in **us-east-2** (AMI IDs differ by region).
2. The `key_name` (`ohio1309`) already exists in your AWS account → otherwise Terraform will fail.
3. The `subnet_id` is from the correct VPC and has internet access if you need SSH.
4. Your AWS credentials are configured (`aws configure`).

---


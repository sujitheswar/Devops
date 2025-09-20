Terraform setup have **two main folders**: `backend-setup` and `ec2-instance`. Here’s a breakdown of each:

---

## **1. backend-setup**

**Files:** `main.tf`, `outputs.tf`

### **main.tf**

* Configures Terraform to use **AWS provider** in `us-east-2`.
* Uses a **data source** to get the current AWS account ID:

```hcl
data "aws_caller_identity" "current" {}
locals {
  account_id = data.aws_caller_identity.current.account_id
}
```

* **S3 bucket**: Stores Terraform state files. Features:

  * Versioning enabled
  * Server-side encryption (AES256)

```hcl
resource "aws_s3_bucket" "terraform_state" { ... }
```

* **DynamoDB table**: For state locking (prevents concurrent modifications):

```hcl
resource "aws_dynamodb_table" "demoterraform_lock" { ... }
```

### **outputs.tf**

* Exposes useful information after applying Terraform:

```hcl
output "s3_bucket_name" { value = aws_s3_bucket.terraform_state.id }
output "s3_bucket_arn"  { value = aws_s3_bucket.terraform_state.arn }
output "dynamodb_table_name" { value = aws_dynamodb_table.demoterraform_lock.name }
```

**Summary:** This folder sets up the **remote backend** (S3 + DynamoDB) for storing Terraform state and locking.

---

## **2. ec2-instance**

**Files:** `main.tf`

### **main.tf**

* Configures Terraform to use AWS provider and sets up **remote state backend** using the S3 bucket and DynamoDB table from `backend-setup`:

```hcl
backend "s3" {
    bucket         = "<accountid>-demoterraform-states"
    key            = "ec2-demo/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "demoterraform-lock"
    encrypt        = true
}
```

* Creates a single **EC2 instance**:

```hcl
resource "aws_instance" "app_server" {
  ami           = "ami-0cfde0ea8edd312d4"
  instance_type = "t3.micro"
  key_name      = "ohio1309"
  subnet_id     = "subnet-078043c28e92411d7"
  associate_public_ip_address = true
  tags = { Name = "Terraform_2Demo" }
}
```

**Summary:** This folder uses the backend from `backend-setup` and provisions an **EC2 instance**.

---

## **How it works together**

1. **backend-setup** is applied first:

   * Creates S3 bucket + DynamoDB table for Terraform state storage and locking.

2. **ec2-instance** uses the backend created in `backend-setup`:

   * Configures the remote backend
   * Creates EC2 instance in the specified subnet

3. **Terraform state**:

   * Stored in S3 (`accountid-demoterraform-states/ec2-demo/terraform.tfstate`)
   * Locked via DynamoDB to prevent multiple users from applying at the same time.

---
**diagram showing how the backend and EC2 instance setup work together**, which makes it very easy to visualize.
<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/54db71a6-d93f-4573-959f-f1d446518cd6" />




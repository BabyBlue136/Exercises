terraform {
  required_version = "~> 1.4.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.9.0"
    }
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "default"
}




resource "aws_s3_bucket" "mybucket" {
  bucket = "my-backup-bucket-szoby"

  tags = {
    Name = "Backup Bucket"
  }
}


# Enable default server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.mybucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_lifecycle_configuration" "glacier" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    id     = "my-lifecycle-rule"
    status = "Enabled"

    transition {
      days          = 0   # Move to Glacier immediately for cost reduction
      storage_class = "GLACIER"
    }

    expiration {
      days = 180   # Backups for 180 days and no more
    }
  }
}


# IAM Policy for the Backup Uploader role
resource "aws_iam_policy" "bucket_policy" {
  name        = "BackupUploaderPolicy"
  description = "IAM policy that will be attached to role backup_uploader, to make sure it is able to upload files into the bucket"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowPutObject"
        Effect   = "Allow"
        Action   = "s3:PutObject"   # Least access
        Resource = "${aws_s3_bucket.mybucket.arn}/*"
      }
    ]
  })
}


# Attach IAM Policy to the IAM Role
resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  policy_arn = aws_iam_policy.bucket_policy.arn
  role       = "backup_uploader"
}
#1 IAM for EC2

# IAM Role + Trust Policy
resource "aws_iam_role" "wordpress_role" {
  name = "wordpress-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# Create an IAM policy for the WordPress EC2 instance 
# This policy allows the instance to write logs, access SSM parameters
resource "aws_iam_policy" "wordpress_policy" {
  name = "wordpress-ec2-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameter"
        ],
        Resource = "*"
      }
    ]
  })
}

# Attach the IAM policy to the WordPress role
resource "aws_iam_role_policy_attachment" "attach_wordpress_policy" {
  role       = aws_iam_role.wordpress_role.name
  policy_arn = aws_iam_policy.wordpress_policy.arn
}

# Create an IAM instance profile for the WordPress EC2 instance
resource "aws_iam_instance_profile" "wordpress_profile" {
  name = "wordpress-instance-profile"
  role = aws_iam_role.wordpress_role.name
}


#2 IAM role for Lambda function

resource "aws_iam_role" "lambda_s3_role" {
  name = "lambda-s3-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_s3_policy" {
  name = "LambdaS3Policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::your-bucket-name",
          "arn:aws:s3:::your-bucket-name/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_s3_attachment" {
  role       = aws_iam_role.lambda_s3_role.name
  policy_arn = aws_iam_policy.lambda_s3_policy.arn
}

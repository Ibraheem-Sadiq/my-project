resource "aws_iam_role" "block_iam_role" {
    name = "iam_role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },    
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
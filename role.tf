resource "aws_iam_role" "ecstaskexecutionrole123" {
  name = "ecstaskexecutionrole123"
  managed_policy_arns = [ "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole" ]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

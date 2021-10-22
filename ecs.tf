resource "aws_ecs_cluster" "myapp-cluster" {
  name = "myapp-cluster"
 }

resource "aws_ecs_task_definition" "myapp-task" {
  family = "myapp-task"
  execution_role_arn  = aws_iam_role.ecstaskexecutionrole123.arn
  network_mode  = "awsvpc" 
  requires_compatibilities = ["FARGATE"]
  cpu = 1024
  memory = 2048
  container_definitions = jsonencode([
    {
      name      = "sample"
      image     = "vikasabdocker/jarvis:myapp"
      cpu       = 1
      memory    = 1024
      network_mode  = "awsvpc"
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
   ])
 }

resource "aws_ecs_service" "myapp-svc" {
  name            = "myapp-svc"
  cluster         = aws_ecs_cluster.myapp-cluster.id
  task_definition = aws_ecs_task_definition.myapp-task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    security_groups  = [aws_security_group.myapp-sg.id]
    subnets          = aws_subnet.myapp-subnet.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.myapp-tg.id
    container_name   = "sample"
    container_port   = 80
  }
}

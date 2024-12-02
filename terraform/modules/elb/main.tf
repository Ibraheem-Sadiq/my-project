# resource "aws_lb" "bolck_lb" {
#     name = "elb"
#     internal = false
#     load_balancer_type = "application"
#     security_groups = var.sg
#     subnets = var.subnets
#     access_logs {
#         bucket = "s3-log"
#         enabled = true
#         prefix = "elb"
#     }
# }

# resource "aws_lb_target_group" "block_tg" {
#     name = "elb-tg"
#     port = 80
#     protocol = "HTTP"
#     vpc_id = var.vpc_id
# }
# resource "aws_lb_target_group_attachment" "block_lb_tg_attachment" {
#   target_group_arn = aws_lb_target_group.block_tg.arn
#   target_id        = var.target_group_instances_id_pu
#   port             = 80
# }
# resource "aws_lb_listener" "block_lb_listener" {
#     load_balancer_arn = aws_lb.bolck_lb.arn
#     port = "80"
#     protocol = "HTTP"
#     default_action {
#         target_group_arn = aws_lb_target_group.block_tg.arn
#         type = "forward"
#     }
  
# }
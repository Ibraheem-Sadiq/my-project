
resource "aws_backup_vault" "block_backup_plan" {
  name = "backup_vault"

}

resource "aws_backup_selection" "block_backup_selection" {
  iam_role_arn = var.iam_role_arn
  name         = "backup_selection"
  plan_id      = aws_backup_plan.block_backup_plan.id
  resources    = var.ec2
}

resource "aws_backup_plan" "block_backup_plan" {
  name = "jenkins_backup_plan"

  rule {
    rule_name         = "backup_rule"
    target_vault_name = "backup_vault"
    schedule          = var.schedule
    #"cron(0 12 * * ? *)"
  }
}

# resource "aws_iam_role_policy_attachment" "name" {
#   role       = aws_iam_role.block_iam_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
# }
resource "aws_eks_cluster" "block_cluster" {
    name = "eks"
    role_arn = var.iam_role_arn
    vpc_config {
        subnet_ids = var.sub_ids
    }
}

resource "aws_eks_node_group" "block_node_group" {
    cluster_name = aws_eks_cluster.block_cluster.name
    node_group_name = "node-group"
    node_role_arn = var.iam_role_arn
    subnet_ids = var.sub_ids
    instance_types = ["t2.micro"]
    scaling_config {
        desired_size = 2
        max_size = 3
        min_size = 1
    }
  
}

resource "aws_eks_addon" "block_kube_proxy" {
    count = 4
    cluster_name = aws_eks_cluster.block_cluster.name
    addon_name = var.addons[count.index]
    
}
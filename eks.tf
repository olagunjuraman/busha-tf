resource "aws_eks_cluster" "busha_cluster" {
  name     = "busha-cluster"
  role_arn = aws_iam_role.busha_eks_cluster_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.busha_subnet1.id, aws_subnet.busha_subnet2.id, aws_subnet.busha_subnet3.id]
  }

  depends_on = [aws_iam_role_policy_attachment.busha_eks_cluster_policy]
}


resource "aws_eks_node_group" "busha_node_group" {
  cluster_name    = aws_eks_cluster.busha_cluster.name
  node_group_name = "busha-node-group"
  node_role_arn   = aws_iam_role.busha_eks_node_role.arn
  subnet_ids      = [aws_subnet.busha_subnet2.id, aws_subnet.busha_subnet3.id]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.busha_eks_worker_node_policy,
    aws_iam_role_policy_attachment.busha_eks_cni_policy,
    aws_iam_role_policy_attachment.busha_eks_ec2_policy,
  ]
}
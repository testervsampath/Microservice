output "endpoint" {
  value = aws_eks_cluster.ekscluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.ekscluster.certificate_authority[0].data
}

output "cluster_id" {
  value = aws_eks_cluster.ekscluster.id
}
output "cluster_endpoint" {
  value = aws_eks_cluster.ekscluster.endpoint
}
output "cluster_name" {
  value = aws_eks_cluster.ekscluster.name
}

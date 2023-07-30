output "address" {
  value = aws_elasticache_replication_group.main.primary_endpoint_address
}

output "cluster_members" {
  value = aws_elasticache_replication_group.main.member_clusters
}

output "security_group_id" {
  value = aws_security_group.main.id
}

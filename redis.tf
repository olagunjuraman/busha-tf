resource "aws_elasticache_cluster" "busha_redis" {
  cluster_id           = "busha-redis"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.x"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.busha_redis_subnet_group.name
  security_group_ids   = [aws_security_group.busha_redis_sg.id]

  tags = {
    Name = "BushaRedis"
  }
}

resource "aws_elasticache_subnet_group" "busha_redis_subnet_group" {
  name       = "busha-redis-subnet-group"
  subnet_ids = [aws_subnet.busha_subnet2.id, aws_subnet.busha_subnet3.id]

  tags = {
    Name = "Busha Redis Subnet Group"
  }
}

resource "aws_security_group" "busha_redis_sg" {
  name        = "busha-redis-sg"
  description = "Security group for Redis allowing specific traffic"
  vpc_id      = aws_vpc.busha_vpc.id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # This allows access from within the VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "BushaRedisSecurityGroup"
  }
}
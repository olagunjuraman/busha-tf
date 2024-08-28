resource "aws_db_instance" "busha_db" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "16.1"
  instance_class       = "db.t3.micro"  
  identifier           = "bushadb"
  username             = var.db_username
  password             = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.busha_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.busha_db_sg.id]

  tags = {
    Name = "BushaDB"
  }

   depends_on = [aws_eks_cluster.busha_cluster]
}

resource "aws_db_subnet_group" "busha_db_subnet_group" {
  name       = "busha-db-subnet-group"
  subnet_ids = [aws_subnet.busha_subnet2.id, aws_subnet.busha_subnet3.id]

  tags = {
    Name = "Busha DB Subnet Group"
  }
}

resource "aws_security_group" "busha_db_sg" {
  name        = "busha-db-sg"
  description = "Security group for PostgreSQL DB allowing specific traffic"

  vpc_id = aws_vpc.busha_vpc.id

  ingress {
    from_port   = 5432  
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "BushaDBSecurityGroup"
  }
}
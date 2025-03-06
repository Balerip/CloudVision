# database.tf
resource "aws_db_instance" "cloudvision_db" {
  allocated_storage    = 20
  storage_type        = "gp2"
  engine              = "postgres"
  instance_class      = "db.t3.micro"
  db_name             = "cloudvision_database"
  username            = "cloudvision_user"
  password            = var.db_password
  skip_final_snapshot = true
  multi_az           = false
  publicly_accessible = true

  tags = {
    Name = "CloudVision-RDS"
  }
}

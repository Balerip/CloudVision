resource "aws_instance" "cloudvision_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.generated_key_pair.key_name

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install docker -y
              sudo service docker start
              sudo usermod -a -G docker ec2-user

              # Create Docker network
              sudo docker network create cloudvision-network

              # Run PostgreSQL container
              sudo docker run -d --name cloudvision-postgres --network cloudvision-network \
                -e POSTGRES_USER=${var.db_username} \
                -e POSTGRES_PASSWORD=${var.db_password} \
                -e POSTGRES_DB=${var.db_name} \
                postgres

              # Run CloudVision container
              sudo docker run -d --name cloudvision-app --network cloudvision-network \
                -p 3000:3000 \
                -e MB_DB_TYPE=postgres \
                -e MB_DB_HOST=cloudvision-postgres \
                -e MB_DB_PORT=5432 \
                -e MB_DB_DBNAME=${var.db_name} \
                -e MB_DB_USER=${var.db_username} \
                -e MB_DB_PASS=${var.db_password} \
                gayatridt/cloudvision:latest
              EOF

  tags = {
    Name = "CloudVision-EC2"
  }

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
}

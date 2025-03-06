CloudVision Deployment Guide
Project Overview
This document outlines the complete deployment process for CloudVision, a rebranded Metabase application, with PostgreSQL database integration using Docker containerization and AWS infrastructure managed through Terraform.
System Architecture
- Application Layer: CloudVision (Metabase-based) Docker container
- Database Layer: PostgreSQL Docker container
- Infrastructure: AWS EC2 instance
- Networking: Docker network for container communication
- Security: AWS Security Groups for access control
Prerequisites
- AWS Account with appropriate permissions
- Docker Hub Account
- Terraform installed locally
- Docker Desktop installed
- Git for version control
- Basic command line knowledge
Deployment Process
1. Local Development Setup
Docker Image Preparation:
Build the CloudVision image:
docker buildx build --platform linux/amd64 -t <dockerhub-username>/cloudvision:latest .
Test local deployment with PostgreSQL:
docker network create cloudvision-network
Run PostgreSQL container:
docker run -d --name cloudvision-postgres --network cloudvision-network \
-e POSTGRES_USER=myuser \
-e POSTGRES_PASSWORD=mypassword \
-e POSTGRES_DB=cloudvisiondb \
postgres
Run CloudVision container:
docker run -d --name cloudvision-app --network cloudvision-network \
-p 3000:3000 \
-e MB_DB_TYPE=postgres \
-e MB_DB_HOST=cloudvision-postgres \
-e MB_DB_PORT=5432 \
-e MB_DB_DBNAME=cloudvisiondb \
-e MB_DB_USER=myuser \
-e MB_DB_PASS=mypassword \
<dockerhub-username>/cloudvision:latest
Verify local deployment:
curl http://localhost:3000
Push to Docker Hub
docker login:
docker push <dockerhub-username>/cloudvision:latest
2. Infrastructure Configuration
Project Structure
cloudvision-project/
├── main.tf Main infrastructure configuration
├── variables.tf Variable definitions
├── outputs.tf Output configurations
├── providers.tf Provider configurations
├── security.tf Security group configurations
└── terraform.tfvars Variable values (git-ignored)
3. Deployment Steps
Initialize and Deploy
Initialize Terraform:
terraform init
Verify deployment plan:
terraform plan
Deploy infrastructure:
terraform apply
Verify Deployment
Get EC2 instance IP:
terraform output instance_public_ip
SSH into instance:
chmod 400 ~/Downloads/generated-key.pem
ssh -i ~/Downloads/generated-key.pem ec2-user@<public-ip>
Verify containers:
sudo docker ps
sudo docker logs cloudvision-app
sudo docker logs cloudvision-postgres
4. Post-Deployment Configuration
Access Application
- Navigate to `http://<ec2-public-ip>:3000`
- Complete initial setup through CloudVision interface
- Verify database connection in application settings
Monitoring and Maintenance
Check container health:
sudo docker ps
sudo docker stats
View application logs:
sudo docker logs cloudvision-app
View database logs:
sudo docker logs cloudvision-postgres
5. Security Considerations
- Secure database credentials using AWS Secrets Manager
- Regularly update security group rules
- Implement SSL/TLS for database connections
- Regular security patches and updates
- Backup strategy for database data
6. Troubleshooting Guide
Common Issues and Solutions
1. Container Startup Issues:
sudo docker restart cloudvision-app
sudo docker logs cloudvision-app
2. Database Connection Issues:
Verify network
sudo docker network inspect cloudvision-network
Restart containers
sudo docker restart cloudvision-postgres
sudo docker restart cloudvision-app
3. Application Access Issues:
- Verify security group settings
- Check EC2 instance status
- Validate container logs
7. Cleanup Procedure
Remove infrastructure:
terraform destroy
Clean local environment
docker rm -f cloudvision-app cloudvision-postgres
docker network rm cloudvision-network
docker rmi <dockerhub-username>/cloudvision:latest
Best Practices
1. Version Control
- Maintain infrastructure code in Git
- Use meaningful commit messages
- Exclude sensitive files (terraform.tfvars)
2. Security
- Use least privilege principle
- Regular security audits
- Implement proper backup strategies
3. Monitoring
- Set up AWS CloudWatch
- Monitor container metrics
- Regular log analysis
Conclusion
This deployment guide provides a comprehensive approach to deploying CloudVision with PostgreSQL integration on AWS infrastructure. Following these steps ensures a reliable and maintainable deployment process suitable for both development and production environments.
---
*Note: Replace placeholder values (`<dockerhub-username>`, `<public-ip>`) with actual values during deployment.*


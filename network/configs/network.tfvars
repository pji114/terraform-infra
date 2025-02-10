vpc-cidr = "10.0.0.0/22"
vpc-name  = "Application-VPC"
subnets = {
  public_a  = { az = "ap-northeast-2a", cidr_idx = 0, subnet_type = "public-a" }
  public_c  = { az = "ap-northeast-2c", cidr_idx = 1, subnet_type = "public-c" }
  private_app_a = { az = "ap-northeast-2a", cidr_idx = 2, subnet_type = "private-app-a" }
  private_app_c = { az = "ap-northeast-2c", cidr_idx = 3, subnet_type = "private-app-c" }
  private_db_a  = { az = "ap-northeast-2a", cidr_idx = 4, subnet_type = "private-db-a" }
  private_db_c  = { az = "ap-northeast-2c", cidr_idx = 5, subnet_type = "private-db-c" }
}
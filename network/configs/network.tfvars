vpc-cidr = "10.0.0.0/22"
vpc-name  = "Application-VPC"
subnets = {
  public_a  = { az = "ap-northeast-2a", cidr_idx = 0, subnet_type = "public" }
  public_c  = { az = "ap-northeast-2c", cidr_idx = 1, subnet_type = "public" }
  private_app_a = { az = "ap-northeast-2a", cidr_idx = 2, subnet_type = "private_app" }
  private_app_c = { az = "ap-northeast-2c", cidr_idx = 3, subnet_type = "private_app" }
  private_db_a  = { az = "ap-northeast-2a", cidr_idx = 4, subnet_type = "private_db" }
  private_db_c  = { az = "ap-northeast-2c", cidr_idx = 5, subnet_type = "private_db" }
}
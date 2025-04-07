resource "aws_ebs_volume" "myvolume" {
    availability_zone = "us-east-1a"
    size = 5
    tags = {
      Name = "tf_volume"
    }
  
}


# Create IAM user with necessary permissions, it will create access key & secrete key
# terraform init
# terraform plan
# terraform apply
# terraform destroy

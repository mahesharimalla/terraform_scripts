provider "aws" {
  region = "us-east-1" # Set your desired AWS region

}


resource "aws_instance" "example" {
  ami           = "ami-0f9de6e2d2f067fca" # Specify an appropriate AMI ID
  instance_type = "t2.micro"
  tags = {
    Name = "terraform-server"                # Always wrap tag values (or any plain text) in double quotes.
  }
}



# terraform init     --> Foundational command in Terraform that initializes a working directory containing Terraform configuration files
# terraform fmt      --> Set right the indentation
# terraform validate --> Find out error
# terraform plan     --> Dry run it shows what will do export the attributes
# terraform apply    --> It will create resources & terraform.tfstate file



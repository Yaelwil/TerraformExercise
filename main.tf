/*
 The terraform {} block contains Terraform settings, including the required providers Terraform will use to provision infrastructure.
 Terraform installs providers from the Terraform Registry by default.
 In this example configuration, the aws provider's source is defined as hashicorp/aws,
*/
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.16"
    }
  }

    backend "s3" {
    bucket = "yaelwil-tf-test"
    key    = "tfstate.json"
    region = "eu-west-1"
    # optional: dynamodb_table = "<table-name>"
  }

  required_version = ">= 1.2.0"
}


/*
 The provider block configures the specified provider, in this case aws.
 You can use multiple provider blocks in your Terraform configuration to manage resources from different providers.
*/
provider "aws" {
  region  = var.region
  profile = "default"
}


/*
 Use resource blocks to define components of your infrastructure.
 A resource might be a physical or virtual component such as an EC2 instance.
 A resource block declares a resource of a given type ("aws_instance") with a given local name ("app_server").
 The name is used to refer to this resource from elsewhere in the same Terraform module, but has no significance outside that module's scope.
 The resource type and name together serve as an identifier for a given resource and so must be unique within a module.

 For full description of this resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
*/
resource "aws_instance" "app_server" {
#   ami           = "ami-0776c814353b4814d"
  ami = var .ami_id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.public_key.key_name
  user_data = file("./deploy.sh")

  tags = {
    Name = "yaelwil-tf-${var.env}"
    Terraform = "true"
  }
}

resource "aws_key_pair" "public_key" {
  key_name   = "yaelwil-tf"  # Key pair name, without the ".pub" extension
  public_key = file(var.public_key_path)  # Path to the public key file
}
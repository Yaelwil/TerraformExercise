variable "env" {
   description = "Deployment environment"
   type        = string
}

variable "region" {
   description = "AWS region"
   type        = string
}

variable "ami_id" {
   description = "EC2 Ubuntu AMI"
   type        = string
}

variable "public_key_path" {
  description = "SSH key"
  type        = string
}
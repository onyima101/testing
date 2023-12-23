# variable "aws_key_path" {}

variable "aws_key_name" {
    description = "AWS Private key for access to EC2"
    default = "ndcc-key"
}

variable "azs" {
    type        = list(string)
    description = "Availability Zones"
    default     = ["us-east-1a", "us-east-1b"]
}

variable "jenkins_ami" {
    description = "AMIs by region"
    default = "ami-0c7217cdde317cfec" #ubuntu 22.04 default 
}


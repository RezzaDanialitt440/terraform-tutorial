variable "instance_name" {
    description = "Name of EC2 instance"
    type        = string
    default     = "Default Instance"
}

variable "ami" {
    description = "AMI to use for EC2 instance"
    type        = string
    default     = "ami-079eb74dd7886186d"
}

variable "instance_type" {
    description = "EC2 instance type"
    type        = string
    default     = "t2.micro"
}
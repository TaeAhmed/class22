variable "ec2_count" {
    default = 1
}
variable "ami_id" {}
variable "instance_type" {
    default = "t2.micro"
}
variable "vpc_id" {}
variable "subnet_id" {}
variable "user_data" {
    default = file(user_data.sh)
}

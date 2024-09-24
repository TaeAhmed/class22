variable "ec2_count" {
    default = 1
}
variable "ami_id" {}
variable "instance_type" {
    default = "db.t2.micro"
}
variable "subnet_id" {}


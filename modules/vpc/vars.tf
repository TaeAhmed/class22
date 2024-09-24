variable "vpc_cidr" {
    default = "10.0.0.0/16"
}
variable "tenancy" {
    default = "default"
}
variable "public_subnet_count" {
    default = 1
}
variable "private_subnet_count" {
    default = 1
}
variable "public_subnet_cidrs" {
    default = ["10.0.1.0/24"]
}
variable "private_subnet_cidrs" {
    default = ["10.0.4.0/24"]
}

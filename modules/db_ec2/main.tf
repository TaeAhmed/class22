resource "aws_instance" "db" {
    count         = var.ec2_count  
    ami           = var.ami_id
    instance_type = var.instance_type
    subnet_id     = var.subnet_id
    user_data     = var.user_data
    lifecycle {
        prevent_destroy = true
        #could not use var or local as they throw errors:
        #err: variables may not be used here
        #err: Unsuitable value: value must be known
    }  
}

resource "aws_instance" "web" {
    count         = var.ec2_count  
    ami           = var.ami_id
    instance_type = var.instance_type
    subnet_id     = var.subnet_id
    lifecycle {
        prevent_destroy = false
        #prevent_destroy = var.prevent_destroy
        #2<< variables may not be used here
        #2<<Unsuitable value: value must be known
    }  
}

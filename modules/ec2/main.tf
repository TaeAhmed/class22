resource "aws_instance" "web" {
  count = "${var.ec2_count}"  
  ami           = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  lifecycle {
    #prevent_destroy = var.prevent_destroy 
    #2<<Unsuitable value: value must be known
  }  
  tags = {
    Name = "HelloWorld"
  }
}

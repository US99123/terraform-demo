terraform {
  source = "G:/dvps/teraform/terraform-demo/environments/modules/ec2"
}
inputs = {
    ami = "ami-0005e0cfe09cc9050"
    instance_type = "t2.micro"
}
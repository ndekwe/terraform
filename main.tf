provider "aws" {
	region = "eu-west-3"
}

resource "aws_instance" "example" {
	ami	="ami-0bb607148d8cf36fb"
	instance_type = "t2.micro"

	tags =  {
	   Name = "terraform-example"
	}
}

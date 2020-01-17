provider "aws" {
	region = "eu-west-3"
}

resource "aws_instance" "advocacy" {
	ami	="ami-0bb607148d8cf36fb"
	instance_type = "t2.micro"
	vpc_security_group_ids = ["${aws_security_group.instance.id}"]

	user_data = <<-EOF
		   #!/bin/bash
		   echo "Hello HashiCorp!" > index.html
		   nohup busybox httpd -f -p "${var.server_port}" &
		   EOF

	tags =  {
	   Name = "terraform-advocacy"
	}
}

resource "aws_launch_configuration" "advocacy" {
        image_id        ="ami-0bb607148d8cf36fb"
        instance_type   = "t2.micro"
        security_groups = ["${aws_security_group.instance.id}"]

        user_data = <<-EOF
                   #!/bin/bash
                   echo "Hello HashiCorp" > index.html
                   nohup busybox httpd -f -p "${var.server_port}" &
                   EOF

        lifecycle {
           create_before_destroy = true
        }
}

resource "aws_security_group" "instance" {
	name = "terraform-advocacy-instance"

	ingress {
		from_port   =  var.server_port
		to_port     =  var.server_port
		protocol    =  "tcp"
		cidr_blocks =  ["0.0.0.0/0"]
	}
	
	lifecycle {
           create_before_destroy = true
        }
}

data "aws_availability_zones" "all" {
}

resource "aws_autoscaling_group" "advocacy" {
        launch_configuration = aws_launch_configuration.advocacy.id
	#availability_zones   = ["${data.aws_availability_zones.all.names}"]
	availability_zones   = ["eu-west-3a", "eu-west-3b","eu-west-3c"]

	load_balancers       = ["${aws_elb.advocacy.name}"]
	health_check_type    = "ELB"

	min_size = 2
	max_size = 10
	desired_capacity     = 3

        tag {
                key   			=  "Name"
                value     		=  "terraform-asg-advocacy"
                propagate_at_launch     = true
        }
}

resource "aws_elb" "advocacy" {
        name                 = "terraform-asg-advocacy"
        #availability_zones   = ["${data.aws_availability_zones.all.names}"]
	availability_zones   = ["eu-west-3a", "eu-west-3b","eu-west-3c"]

        listener {
                lb_port                     =  80
                lb_protocol                 =  "http"
                instance_port               =  var.server_port
		instance_protocol           =  "http"
        }

	health_check {
		healthy_threshold	    = 2
		unhealthy_threshold         = 2
		timeout			    = 3
		interval 		    = 30 
		target			    = "HTTP:${var.server_port}/"
	}
}

resource "aws_security_group" "elb" {
        name = "terraform-advocacy-elb"

        ingress {
                from_port   =  80
                to_port     =  80
                protocol    =  "tcp"
                cidr_blocks =  ["0.0.0.0/0"]
        }

	egress {
                from_port   =  0
                to_port     =  0
                protocol    =  -1
                cidr_blocks =  ["0.0.0.0/0"]
        }

}

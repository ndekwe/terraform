
# output "public_ip" {
#       value = "${aws_instance.advocacy.public_ip}"
# }



output "elb_dns_name" {
     value = "${aws_elb.advocacy.dns_name}"
}

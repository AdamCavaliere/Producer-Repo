output "main_vpc" {
  value = "${aws_vpc.main.id}"
}

output "default_security_group_id" {
  value = "${aws_vpc.main.default_security_group_id}"
}
output "research_subnet_id" {
  value = "${aws_subnet.research.id}"
}

output "test_subnet_id" {
  value = "${aws_subnet.test.id}"
}

output "prod_subnet_id" {
  value = "${aws_subnet.prod.id}"
}

output "region" {
  value = "${var.aws_region}"
}

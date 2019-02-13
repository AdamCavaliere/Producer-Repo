output "main_vpc" {
  value = "${aws_vpc.main.id}"
}

output "development_subnet_id" {
  value = "${aws_subnet.research.id}"
}

output "staging_subnet_id" {
  value = "${aws_subnet.test.id}"
}

output "production_subnet_id" {
  value = "${aws_subnet.prod.id}"
}

output "region" {
  value = "${var.aws_region}"
}

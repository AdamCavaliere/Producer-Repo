output "main_vpc" {
  value = "${aws_vpc.main.id}"
}

output "development_subnet_id" {
  value = "${aws_subnet.development.id}"
}

output "staging_subnet_id" {
  value = "${aws_subnet.staging.id}"
}

output "production_subnet_id" {
  value = "${aws_subnet.production.id}"
}

output "region" {
  value = "${var.aws_region}"
}

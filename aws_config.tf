provider "aws" {
  access_key = "${var.master_aws_access_key}"
  secret_key = "${var.master_aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "research" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"

  tags {
    Name = "research"
  }
}

resource "aws_subnet" "test" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.2.0/24"

  tags {
    Name = "test"
  }
}

resource "aws_subnet" "prod" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.3.0/24"

  tags {
    Name = "prod"
  }
}

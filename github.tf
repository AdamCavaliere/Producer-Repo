variable "git_token" {}
variable "git_repo" {}

data "template_file" "init" {
  template = "${file("curl.tmpl")}"
  vars = {
    git_token = "${var.git_token}"
    git_repo = "${var.git_repo}"
    git_user = "${var.git_user}"
  }
}


resource "null_resource" "example1" {
  provisioner "local-exec" {
    command = "${data.template_file.init.rendered}"
  }
}


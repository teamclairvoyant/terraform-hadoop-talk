resource "null_resource" "hadoop-deployment-bash" {
  provisioner "local-exec" {
    command = "git clone --depth 1 https://github.com/teamclairvoyant/hadoop-deployment-bash hadoop-deployment-bash"
  }
}


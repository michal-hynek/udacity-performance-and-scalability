provider "aws" {
    region = var.region
}

resource aws_instance micro_instance {
    count = 4
    ami = var.ami
    instance_type = "t2.micro"
    subnet_id = var.subnet

    tags = {
        Name = "Udacity T2"
    }
}

resource aws_instance large_instance {
    count = 2
    ami = var.ami
    instance_type = "m4.large"
    subnet_id = var.subnet

    tags = {
        Name = "Udacity M4"
    }
}
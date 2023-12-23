/*
  Web Servers
*/
resource "aws_instance" "web-1" {
    ami =  "${var.jenkins_ami}" 
    availability_zone = element(var.azs, count.index) #"${lookup(var.azs)}"
    instance_type = "t3.small"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.web.id}"]
    subnet_id = aws_subnet.public-us-east-1a.id #"${aws_subnet.us-east-1a-public.id}"
    count = 1
    associate_public_ip_address = true
    source_dest_check = false
    user_data              = templatefile("./install.sh", {})

    # root_block_device {
    #   volume_size = 20
    # }

    tags = {
        Name = "Jenkins"
    }
}

resource "aws_eip" "web-1" {
    count = 1
    instance = aws_instance.web-1[count.index].id
}

resource "aws_key_pair" "my_key_pair" {
#   key_name   = "${var.aws_key_name}"
  public_key = file("~/.aws/ndcc-key.pub")
}

resource "aws_security_group" "web" {
    name = "main_web"
    description = "Allow incoming HTTP connections."

    ingress = [
        for port in [22, 80, 443, 8080, 9000, 3000] : {
            description      = "inbound rules"
            from_port        = port
            to_port          = port
            protocol         = "tcp"
            cidr_blocks      = ["0.0.0.0/0"]
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            security_groups  = []
            self             = false
        }
    ]

    egress { 
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.main.id}"

    tags = {
        Name = "JenkinsSG"
    }
}
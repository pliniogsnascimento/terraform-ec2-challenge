# TODO: Create ec2 with nginx user data
data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_network_interface" "instance_a" {
  subnet_id = aws_subnet.public_subnet_a.id
  # security_groups = [aws_security_group.main_sg.name]

  tags = {
    Name = "primary_network_interface"
  }
}


resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.main_sg.id
  network_interface_id = aws_instance.instance_a.primary_network_interface_id
}

resource "aws_instance" "instance_a" {
  ami           = data.aws_ami.this.id
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.instance_a.id
    device_index         = 0
  }

  user_data = file("${path.module}/user_data.sh")
}

resource "aws_eip" "instance_a" {
  instance = aws_instance.instance_a.id
  domain   = "vpc"

  depends_on = [aws_internet_gateway.igw]
}

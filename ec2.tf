# TODO: Create ec2 with nginx user data
data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]
}

resource "aws_network_interface" "instance_a" {
  subnet_id = aws_subnet.public_subnet_a.id

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "instance_a" {
  ami           = data.aws_ami.this.id
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.instance_a.id
    device_index         = 0
  }

}

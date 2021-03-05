data "aws_ami" "os_windows" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*.0-x86_64-gp2"]
  }
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.os_windows.id # us-west-2 ## windows server 2019
  instance_type               = var.instance_size
  associate_public_ip_address = true
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = concat(var.security_group_ids, [aws_security_group.bastion.id])
  iam_instance_profile        = aws_iam_instance_profile.bastion_profile.id

  key_name = aws_key_pair.bastion.key_name

  tags = merge(var.default_tags, {
    Name = "${var.base_name}-bastion"
  })
}

resource "tls_private_key" "bastion" {
  algorithm = "RSA"
}

resource "aws_key_pair" "bastion" {
  key_name   = "${var.base_name}-bastion-kp"
  public_key = tls_private_key.bastion.public_key_openssh

  tags = merge(var.default_tags, {
    Name = "${var.base_name}-bastion-kp"
  })
}

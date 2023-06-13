# creation d'une instance ec2
# choix de l'ami aws linux 2 car contient dejà ssm manager d'installé
data "aws_ami" "amazon_linux_2_ssm" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}
resource "aws_instance" "linux" {
  ami=data.aws_ami.amazon_linux_2_ssm.id
  instance_type=var.instance_type
  iam_instance_profile=aws_iam_instance_profile.ssm-allow.name
  subnet_id=aws_subnet.private.id
     tags={
    Name=var.tag_name
  }
}
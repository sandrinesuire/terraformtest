# pour permettre la connection à l'instance ec2 sans passer par ssh
resource "aws_iam_role" "ssm" { # ssm pour session manager
  name="ec2-ssm-access"
  assume_role_policy=file("Policies/EC2Assumerole.json")
}
# atacher les policies au role
resource "aws_iam_policy_attachment" "attache-ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  name ="Attache SSMPolicy"
  roles =[aws_iam_role.ssm.name]

}
resource  "aws_iam_instance_profile" "ssm-allow" {
  name="SSM-Allow"
  role=aws_iam_role.ssm.name
}
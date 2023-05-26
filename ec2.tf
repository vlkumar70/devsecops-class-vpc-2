## Security group
data "external" "whatismyip" {
  program = ["/bin/bash", "${path.module}/files/whatismyip.sh"]
}

resource "aws_security_group" "allow_ssh" {
  name        = "devsecops-public-sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.devops-vpc.id

  # ingress {
  #   description = "SSH from my ip"
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = [format("%s/%s", data.external.whatismyip.result["internet_ip"], 32)]
  # }

  # ingress {
  #   description = "SSH from my ip"
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = [format("%s/%s", data.external.whatismyip.result["internet_ip"], 32)]
  # }

  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = [format("%s/%s", data.external.whatismyip.result["internet_ip"], 32)]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devsecops-public-sg"
  }
}

# IAM Role
resource "aws_iam_role" "iam_for_ec2" {
  name = "devsecops-s3-sqs-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "iam_profile" {
  name = "devsecops-s3-sqs-profile"
  role = aws_iam_role.iam_for_ec2.name

  depends_on = [aws_iam_role.iam_for_ec2]
}

# IAM policy document
data "aws_iam_policy_document" "policy" {
  statement {
    sid       = "SqsAndS3Access"
    effect    = "Allow"
    actions   = ["sqs:*", "s3:*"]
    resources = ["*"]
  }

  statement {
    sid       = "IamDescribe"
    effect    = "Allow"
    actions   = ["iam:Describe*"]
    resources = ["*"]
  }
}

# IAM policy
resource "aws_iam_policy" "iam_role_policy" {
  name        = "devsecops-sqs-s3-policy"
  description = "devsecops-sqs-s3-policy"
  policy      = data.aws_iam_policy_document.policy.json
}

# IAM policy attachment to role
resource "aws_iam_policy_attachment" "iam_role_policy-attach" {
  name       = "lambda_iam_role_policy_attach"
  roles      = [aws_iam_role.iam_for_ec2.name]
  policy_arn = aws_iam_policy.iam_role_policy.arn
}

# This function will get the latest ami id from AMI list
data "aws_ami" "amazon-linux-2" {
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

# This block will create the aws ec2 instance
resource "aws_instance" "devsecops-public-ec2" {
  ami                         = data.aws_ami.amazon-linux-2.id
  availability_zone           = local.az_1a
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.iam_profile.name
  associate_public_ip_address = true
  key_name                    = var.instance_keypair
  subnet_id                   = aws_subnet.public-subnet-1a.id
  security_groups             = [aws_security_group.allow_ssh.id]
  user_data                   = file("files/apache_config.sh")
  tenancy                     = "default"

  tags = {
    Name = var.instance_name
  }

  depends_on = [
    aws_iam_instance_profile.iam_profile,
    aws_security_group.allow_ssh,
    aws_subnet.public-subnet-1a
  ]
}


## Provisionsers (null_resource, local-exec, remote-exec)

resource "null_resource" "example_provisioner" {
  triggers = {
    public_ip = aws_instance.devsecops-public-ec2.public_ip
  }

  connection {
    type  = "ssh"
    host  = aws_instance.devsecops-public-ec2.public_ip
    user  = var.ssh_user
    port  = var.ssh_port
    agent = true
  }

  # // copy our example script to the server
  # provisioner "file" {
  #   source      = "files/get-public-ip.sh"
  #   destination = "/tmp/get-public-ip.sh"
  # }

  # // change permissions to executable and pipe its output into a new file
  # provisioner "remote-exec" {
  #   inline = [
  #     "chmod +x /tmp/get-public-ip.sh",
  #     "/tmp/get-public-ip.sh > /tmp/public-ip",
  #   ]
  # }

  # provisioner "local-exec" {
  #   # copy the public-ip file back to CWD, which will be tested
  #   command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${var.ssh_user}@${aws_instance.devsecops-public-ec2.public_ip}:/tmp/public-ip public-ip"
  # }
}

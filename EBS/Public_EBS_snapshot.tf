# AWS Provider configuration
provider "aws" {
  region = "us-east-1"
}

# . Public EBS snapshot (misconfiguration)
resource "aws_ebs_volume" "example_volume" {
  availability_zone = "us-east-1a"
  size              = 8
  
  tags = {
    Name = "TestVolume"
  }
}

resource "aws_ebs_snapshot" "public_snapshot" {
  volume_id = aws_ebs_volume.example_volume.id
  
  tags = {
    Name = "PublicSnapshot"
  }
}

# Use a null_resource with local-exec provisioner to make the snapshot public
resource "null_resource" "make_snapshot_public" {
  depends_on = [aws_ebs_snapshot.public_snapshot]
  
  provisioner "local-exec" {
    command = "aws ec2 modify-snapshot-attribute --snapshot-id ${aws_ebs_snapshot.public_snapshot.id} --attribute createVolumePermission --operation-type add --group-names all"
  }
}

# Random string to make resource names unique
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}
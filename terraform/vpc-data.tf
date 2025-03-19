data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.main.id]
  }

  filter {
    name   = "tag:Type"
    values = ["public"]
  }
}

data "aws_subnet" "public_subnet_2a" {
  id = element(data.aws_subnets.public_subnets.ids, 0)
}

data "aws_subnet" "public_subnet_2b" {
  id = element(data.aws_subnets.public_subnets.ids, 1)
}
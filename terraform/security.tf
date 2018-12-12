/////////////////////////
// Base OS Rules

resource "aws_security_group" "base_linux" {
  name        = "base_linux_${random_id.instance_id.hex}"
  description = "base security rules for all linux nodes"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name          = "${var.tag_customer}-${var.tag_project}-base-linux-security-group-${random_id.instance_id.hex}"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
}

resource "aws_security_group" "habitat_supervisor" {
  name        = "habitat_supervisor_${random_id.instance_id.hex}"
  description = "Security rules for the Habitat supervisor"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name          = "${var.tag_customer}-${var.tag_project}-habitat-supervisor-security-group-${random_id.instance_id.hex}"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
}

resource "aws_security_group" "vault" {
  name        = "vault_${random_id.instance_id.hex}"
  description = "Security rules for vault"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name          = "${var.tag_customer}-${var.tag_project}-${var.tag_application_vault}-vault-security-group-${random_id.instance_id.hex}"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application_vault}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
}

resource "aws_security_group" "consul" {
  name        = "consul_${random_id.instance_id.hex}"
  description = "Security rules for consul"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name          = "${var.tag_customer}-${var.tag_project}-${var.tag_application_consul}-vault-security-group-${random_id.instance_id.hex}"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application_consul}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
}

//////////////////////////
// Base Linux Rules
# SSH
resource "aws_security_group_rule" "ingress_allow_22_tcp_all" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.base_linux.id}"
}

# Allow all egress
resource "aws_security_group_rule" "linux_egress_allow_0-65535_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.base_linux.id}"
}

/////////////////////////
// Habitat Supervisor Rules
# Allow Habitat Supervisor http communication tcp
resource "aws_security_group_rule" "ingress_allow_9631_tcp" {
  type                     = "ingress"
  from_port                = 9631
  to_port                  = 9631
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = "${aws_security_group.habitat_supervisor.id}"
}

# Allow Habitat Supervisor http communication udp
resource "aws_security_group_rule" "ingress_allow_9631_udp" {
  type                     = "ingress"
  from_port                = 9631
  to_port                  = 9631
  protocol                 = "udp"
  security_group_id        = "${aws_security_group.habitat_supervisor.id}"
  source_security_group_id = "${aws_security_group.habitat_supervisor.id}"
}

# Allow Habitat Supervisor ZeroMQ communication tcp
resource "aws_security_group_rule" "ingress_9638_tcp" {
  type                     = "ingress"
  from_port                = 9638
  to_port                  = 9638
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.habitat_supervisor.id}"
  cidr_blocks              = ["0.0.0.0/0"]
}

# Allow Habitat Supervisor ZeroMQ communication udp
resource "aws_security_group_rule" "ingress_allow_9638_udp" {
  type                     = "ingress"
  from_port                = 9638
  to_port                  = 9638
  protocol                 = "udp"
  security_group_id        = "${aws_security_group.habitat_supervisor.id}"
  cidr_blocks              = ["0.0.0.0/0"]
}

//////////////////////////
// Base vault Rules
resource "aws_security_group_rule" "ingress_allow_8200_tcp_all" {
  type              = "ingress"
  from_port         = 8200
  to_port           = 8200
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.vault.id}"
}

//////////////////////////
// Base consul Rules
resource "aws_security_group_rule" "ingress_allow_8500_tcp_all" {
  type              = "ingress"
  from_port         = 8500
  to_port           = 8500
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.consul.id}"
}

resource "aws_security_group_rule" "ingress_allow_8600_tcp_all" {
  type              = "ingress"
  from_port         = 8600
  to_port           = 8600
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.consul.id}"
}

resource "aws_security_group_rule" "ingress_allow_8300_tcp_all" {
  type              = "ingress"
  from_port         = 8300
  to_port           = 8300
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.consul.id}"
}

resource "aws_security_group_rule" "ingress_allow_8301_tcp_all" {
  type              = "ingress"
  from_port         = 8301
  to_port           = 8301
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.consul.id}"
}

resource "aws_security_group_rule" "ingress_allow_8302_tcp_all" {
  type              = "ingress"
  from_port         = 8302
  to_port           = 8302
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.consul.id}"
}

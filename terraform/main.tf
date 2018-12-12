provider "aws" {
  region                  = "${var.aws_region}"
  profile                 = "${var.aws_profile}"
  shared_credentials_file = "~/.aws/credentials"
}

resource "random_id" "instance_id" {
  byte_length = 4
}

////////////////////////////////
// Instance Data

// Create 4 consul nodes
resource "aws_instance" "consul" {
  connection {
    user        = "${var.instance_user}"
    private_key = "${file("${var.aws_key_pair_file}")}"
  }

  count = 4

  ami                    = "${var.instance_ami}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.aws_key_name}"
  subnet_id              = "${var.subnet_id}"
  vpc_security_group_ids = [
    "${aws_security_group.base_linux.id}",
    "${aws_security_group.habitat_supervisor.id}",
    "${aws_security_group.consul.id}"
  ]

  provisioner "habitat" {
    peer               = "${aws_instance.consul.0.private_ip}"
    use_sudo           = true
    service_type       = "systemd"
    url                = "${var.habitat_depot_url}"
    builder_auth_token = "${file("${var.habitat_auth_token}")}"
    ring_key_content   = "${file("${var.habitat_ring_key_file}")}"

    service {
      name      = "${var.habitat_origin}/consul"
      channel   = "${var.consul_channel}"
      topology  = "${var.consul_topology}"
      user_toml = "${file("conf/consul.toml")}"
    }
  }

  tags {
    Name          = "${format("${var.tag_prefix}-${var.tag_customer}-${var.tag_application_consul}-%02d-${var.tag_environment}-${random_id.instance_id.hex}", count.index + 1)}"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application_consul}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
}

// Create 3 vault nodes
resource "aws_instance" "vault" {
  connection {
    user        = "${var.instance_user}"
    private_key = "${file("${var.aws_key_pair_file}")}"
  }

  count = 3

  ami                    = "${var.instance_ami}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.aws_key_name}"
  subnet_id              = "${var.subnet_id}"
  vpc_security_group_ids = [
    "${aws_security_group.base_linux.id}",
    "${aws_security_group.habitat_supervisor.id}",
    "${aws_security_group.vault.id}"
  ]

  provisioner "habitat" {
    peer               = "${aws_instance.consul.0.private_ip}"
    use_sudo           = true
    service_type       = "systemd"
    url                = "${var.habitat_depot_url}"
    builder_auth_token = "${file("${var.habitat_auth_token}")}"
    ring_key_content   = "${file("${var.habitat_ring_key_file}")}"

    service {
      name      = "${var.habitat_origin}/vault"
      channel   = "${var.vault_channel}"
      topology  = "${var.vault_topology}"
      user_toml = "${file("conf/vault.toml")}"
      bind {
        alias = "backend"
        service = "consul"
        group = "default"
      }
    }
  }

  tags {
    Name          = "${format("${var.tag_prefix}-${var.tag_customer}-${var.tag_application_vault}-%02d-${var.tag_environment}-${random_id.instance_id.hex}", count.index + 1)}"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application_vault}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
}

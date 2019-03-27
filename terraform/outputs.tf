output "consul_public_ip" {
  value = "${aws_instance.consul.*.public_ip}"
}

output "vault_public_ip" {
  value = "${aws_instance.vault.*.public_ip}"
}

output "consul_ui" {
  value = "http://${aws_instance.consul.0.public_dns}:8500/ui"
}

output "vault_ui" {
  value = "http://${aws_instance.vault.0.public_dns}:8200/ui"
}

output "vault_token" {
  value = "curl -s ${aws_instance.vault.0.public_dns}:9631/census | jq -r '.[\"census_groups\"][\"vault.default\"].service_config.value.token'"
}

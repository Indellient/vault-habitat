pkg_name=consul
pkg_origin=indellient
pkg_version=1.4.3
pkg_description="Consul is a tool for service discovery, monitoring and configuration."
pkg_license=("MPL-2.0")
pkg_upstream_url=https://www.consul.io/
pkg_deps=(core/curl core/consul/1.4.3)
pkg_svc_user=root
pkg_svc_group=root

pkg_exports=(
  [port-dns]=ports.dns
  [port-http]=ports.http
  [port-serf_lan]=ports.serf_lan
  [port-serf_wan]=ports.serf_wan
  [port-server]=ports.server
)
pkg_exposes=(port-dns port-http port-serf_lan port-serf_wan port-server)


do_download() {
  return 0
}

do_unpack() {
  return 0
}

do_build() {
  return 0
}

do_install() {
  return 0
}

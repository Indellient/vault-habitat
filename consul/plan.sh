pkg_origin=sirajrauff
pkg_name=consul
pkg_version=1.4.0
pkg_description="Consul is a tool for service discovery, monitoring and configuration."
pkg_maintainer='The Habitat Maintainers <humans@habitat.sh>'
pkg_license=("MPL-2.0")
pkg_upstream_url=https://www.consul.io/
pkg_filename="${pkg_name}_${pkg_version}_linux_amd64.zip"
pkg_source="https://releases.hashicorp.com/${pkg_name}/${pkg_version}/${pkg_filename}"
pkg_shasum=41f8c3d63a18ef4e51372522c1e052618cdfcffa3d9f02dba0b50820e8279824
pkg_bin_dirs=(bin)
pkg_deps=(core/curl)
pkg_exports=(
  [port-dns]=ports.dns
  [port-http]=ports.http
  [port-serf_lan]=ports.serf_lan
  [port-serf_wan]=ports.serf_wan
  [port-server]=ports.server
)
pkg_exposes=(port-dns port-http port-serf_lan port-serf_wan port-server)

pkg_svc_user=root
pkg_svc_group=root

do_build() {
  return 0
}

do_install() {
  install -D "${HAB_CACHE_SRC_PATH}"/consul "${pkg_prefix}"/bin/consul
}

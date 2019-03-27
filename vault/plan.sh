pkg_name=vault
pkg_origin=indellient
pkg_version=1.1.0
pkg_description="A tool for managing secrets."
pkg_license=("MPL-2.0")
pkg_upstream_url="https://bldr.habitat.sh/#/pkgs/core/consul"
pkg_deps=(core/curl core/gawk core/jq-static core/vault/1.1.0)
pkg_svc_user=root
pkg_svc_group=root

pkg_exports=(
  [protocol]=listener.protocol
  [port]=listener.port
)
pkg_exposes=(port)
pkg_binds=(
  [backend]="port-http"
)

do_unpack() {
  return 0
}

do_build() {
  return 0
}

do_install() {
  return 0
}

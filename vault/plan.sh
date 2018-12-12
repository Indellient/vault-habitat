pkg_name=vault
pkg_origin=sirajrauff
pkg_version=1.0.0
pkg_description="A tool for managing secrets."
pkg_maintainer='The Habitat Maintainers <humans@habitat.sh>'
pkg_license=("MPL-2.0")
pkg_upstream_url=https://www.vaultproject.io/
pkg_filename="${pkg_name}_${pkg_version}_linux_amd64.zip"
pkg_source="https://releases.hashicorp.com/${pkg_name}/${pkg_version}/${pkg_filename}"
pkg_shasum=75afb647d2ebeb46aafbf147ed1f1b379f6b8c9f909550dc2d0976cf153e8aa6
pkg_bin_dirs=(bin)
pkg_deps=(core/curl core/gawk core/jq-static)
pkg_exports=(
  [protocol]=listener.protocol
  [port]=listener.port
  [token]=config.token
)
pkg_exposes=(port)
pkg_binds=(
  [backend]="port-http"
)

pkg_svc_user=root
pkg_svc_group=root

do_build() {
  return 0
}

do_install() {
  install -D "${HAB_CACHE_SRC_PATH}"/vault "${pkg_prefix}"/bin/vault
}

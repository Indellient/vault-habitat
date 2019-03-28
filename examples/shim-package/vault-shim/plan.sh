pkg_name=vault-shim
pkg_origin=bluepipeline
pkg_version=1.0.0
pkg_description="A shim package for a non-Habitat Vault."
pkg_license=("MPL-2.0")
pkg_upstream_url=https://www.vaultproject.io/
pkg_svc_user=root
pkg_svc_group=root

pkg_exports=(
  [port]=port
  [ip-address]=ip-address
)
pkg_exposes=(port)

do_unpack() {
  return 0
}

do_build() {
  return 0
}

do_install() {
  return 0
}

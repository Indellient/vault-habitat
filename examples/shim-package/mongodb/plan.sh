pkg_origin=learn-chef
pkg_name=mongodb-parks
pkg_version=3.2.9
pkg_description="MongoDB for the National Parks app"
pkg_maintainer="The Chef Training Team <training@chef.io>"
pkg_license=('AGPL-3.0')
pkg_deps=(
  core/mongodb/3.2.10
  core/mongo-tools/3.2.10
  core/vault/1.0.3
  core/jq-static
)
pkg_svc_run="mongod --config $pkg_svc_config_path/mongod.conf"
pkg_svc_user=root
pkg_svc_group=root

pkg_exports=(
  [vault-role]=vault.client-role
  [db]=mongod.db.name
  [port]=mongod.net.port
)

pkg_binds=(
  [vault]="port"
)

do_build() {
  return 0
}

do_install() {
  cp -r $PLAN_CONTEXT/national-parks.json $pkg_prefix/
}

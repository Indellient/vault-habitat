pkg_name=national-parks
pkg_origin=sirajrauff-public
pkg_version="0.1.0"
pkg_maintainer="The Chef Training Team <training@chef.io>"
pkg_license=('Apache-2.0')
pkg_build_deps=( core/maven )
pkg_deps=( core/tomcat8 core/jre8 core/vault core/jq-static )
pkg_svc_user=root

pkg_binds=(
  [database]="port db vault-role"
  [vault]="port"
)

do_build() {
  mvn package
}
do_install() {
  cp target/$pkg_name.war $pkg_prefix
}

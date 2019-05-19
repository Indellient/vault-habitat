pkg_name=vault_haproxy
pkg_origin=indellient
pkg_description="The Reliable, High Performance TCP/HTTP Load Balancer"
pkg_version=1.6.11
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_license=('GPL-2.0' 'LGPL-2.1')
pkg_svc_run="haproxy -f $pkg_svc_config_path/haproxy.conf -db"
pkg_svc_user="root"
pkg_svc_group="root"
pkg_exports=(
  [port]=front-end.port
  [status-port]=status.port
)
pkg_exposes=(port status-port)
pkg_binds=(
  [backend]="port"
  [consul]="port-http"
)
pkg_deps=(core/haproxy core/openssl)

# Below is the default behavior for this callback. Anything you put in this
# callback will override this behavior. If you want to use default behavior
# delete this callback from your plan.
# @see https://www.habitat.sh/docs/reference/plan-syntax/#callbacks
# @see https://github.com/habitat-sh/habitat/blob/master/components/plan-build/bin/hab-plan-build.sh
do_download() {
    return 0
}

# Below is the default behavior for this callback. Anything you put in this
# callback will override this behavior. If you want to use default behavior
# delete this callback from your plan.
# @see https://www.habitat.sh/docs/reference/plan-syntax/#callbacks
# @see https://github.com/habitat-sh/habitat/blob/master/components/plan-build/bin/hab-plan-build.sh
do_build() {
    return 0
}

# Below is the default behavior for this callback. Anything you put in this
# callback will override this behavior. If you want to use default behavior
# delete this callback from your plan.
# @see https://www.habitat.sh/docs/reference/plan-syntax/#callbacks
# @see https://github.com/habitat-sh/habitat/blob/master/components/plan-build/bin/hab-plan-build.sh
do_install() {
    return 0
}

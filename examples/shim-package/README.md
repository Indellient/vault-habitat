# Example: Non-Habitat Vault (shim-package)

This example makes use of a Java Web Application "National-Parks" that runs on Apache Tomcat and reads from a MongoDB database.

In this example we have modified our application using an open source Java Vault driver. This application now requires system properties for the `secret-id` and `role-id` to be set, however, we have not yet completed the transition to Habitat at this organization so we must use an existing non-Habitat Vault Cluster.

To make use of the non-Habitat Vault and still benefit from Habitat's Supervisor Ring, bindings and dynamic configuration updates, we create a shim package which takes a vault address and port as parameters and exports these for other packages to use. This means that we can still make use of service discovery and dynamically update the endpoint or port should we require, allowing any number of applications to dynamically reconfigure using Supervisor Rings when the values change.

## Setup

For this tutorial, we will be using a docker Habitat Studio, and as such we will need to set specific docker options to ensure the ports are correctly exposed to our host machine. You can skip the exporting of these options if you are using a local studio on Windows or Linux (macOS requires Docker Studios).

_Note: If you're making use of the Vault & Consul packages in this repository as we do in this example, enter the studio at the root directory allowing the directory to be mounted in the studio_

```
$ export HAB_DOCKER_OPTS="-p 8080:8080 -p 8200:8200 -p 8500:8500"
$ hab studio enter -D

[0][default:/src:0]#
```

Build & launch consul and vault, using bindings to set consul as the Vault's back end:

```
# Build & launch consul
build consul
source results/last_build.env
hab svc load $pkg_ident

# Build & Launch vault
build vault
source results/last_build.env
hab svc load $pkg_ident --bind backend:consul.default
```

_Note: Remember you can use `sup-log` in the studio as a shortcut to tail the supervisor's log and see Vault & Consul logging._

Export the Vault Root token after retrieving it from the Supervisor's HTTP API endpoint and query vault's status; note the need to install & binlink both curl & jq:

```
hab pkg install -b core/curl
hab pkg install -b core/jq-static
export VAULT_TOKEN=$(curl localhost:9631/services/vault/default/config | jq -r '.token')

export VAULT_ADDR=http://localhost:8200
hab pkg binlink core/vault
vault status
```

Looking now at our database (inside `mongodb/`) we see the use of vault paths `secret/mongodb/username` and `secret/mongodb/password` (e.g. in init & post-run hooks):

```
MONGODB_ADMIN_USERNAME=$(vault kv get -field=username secret/mongodb/username)
MONGODB_ADMIN_PASSWORD=$(vault kv get -field=password secret/mongodb/password)
```

Populate these values and enable the Vault database engine.

```
vault secrets enable database
vault kv put secret/mongodb/username username=admin
vault kv put secret/mongodb/password password=<insert a real password here>
```

Looking at the plan & default.toml we require a role-id, client-role & secret-id for AppRole authentication. We can set this up with the following commands:

```
# Enable approle
vault auth enable approle

# Create vault policy for MongoDB
vault policy write mongodb - <<EOF
path "auth/approle/login" {
  capabilities = [ "create" ]
}

path "secret/mongodb/username" {
  capabilities = [ "read" ]
}

path "secret/mongodb/password" {
  capabilities = [ "read" ]
}

path "database/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}
EOF

# Create role for mongo db, using the role created above
vault write auth/approle/role/mongodb \
  secret_id_ttl=15m \
  token_num_uses=40 \
  token_ttl=15m \
  token_max_ttl=15m \
  policies=mongodb \
  secret_id_num_uses=40
```

Let's now make use of a [`user.toml`](https://www.habitat.sh/docs/using-habitat/#using-a-user-toml-file) file to override the `default.toml` values for this machine. Compared to regular configuration applications in Habitat, `user.toml` values are not propagated throughout the ring; this can be ideal for machine specific configurations such as license keys or in this case per-machine vault configurations.

Build and load `mongodb-parks`.

```
mkdir -p /hab/user/mongodb-parks/config

cat > /hab/user/mongodb-parks/config/user.toml <<EOF
[vault]
role-id   = "$(vault read --format "json" auth/approle/role/mongodb/role-id | jq -r .data.role_id)"
secret-id = "$(vault write -f --format "json" auth/approle/role/mongodb/secret-id | jq -r .data.secret_id)"
EOF

build examples/shim-package/mongodb
source results/last_build.env
hab svc load $HAB_ORIGIN/mongodb-parks --bind vault:vault.default
```

This package will also enable the database secret engine if it is not enabled, and will configure the MongoDB plugin for this database in Vault. This is done through a templated hook file (post-run), allowing this to be updated through configuration changes. We also expose the `client-role` configuration option, allowing our applications to dynamically configure themselves to authenticate for this database against the exact role that we have configured in this package.

## Example

The Habitat package for this application requires a `secret-id` and `role-id` just as we used for mongodb-parks. Create the policy & role, and provision the `user.toml` file with the appropriate secrets.

```
# Create vault policy for application
vault policy write application - <<EOF
path "auth/approle/login" {
  capabilities = [ "create", "read" ]
}

path "database/creds/mongodb-client" {
  capabilities = [ "read" ]
}
EOF

vault write auth/approle/role/application \
  secret_id_ttl=15m \
  token_num_uses=10 \
  token_ttl=15m \
  token_max_ttl=15m \
  policies=application \
  secret_id_num_uses=10

mkdir -p /hab/user/national-parks/config

cat > /hab/user/national-parks/config/user.toml <<EOF
[vault]
role-id   = "$(vault read --format "json" auth/approle/role/application/role-id | jq -r .data.role_id)"
secret-id = "$(vault write -f --format "json" auth/approle/role/application/secret-id | jq -r .data.secret_id)"
EOF
```

Build the shim-package and properly set the IP & port:

```
mkdir -p /hab/user/vault-shim/config
cat > /hab/user/vault-shim/config/user.toml <<EOF
port       = "$(curl localhost:9631/services/vault/default/config | jq -r .listener.port)"
ip-address = "$(curl localhost:9631/services/vault/default | jq -r .sys.ip)"
EOF

build examples/shim-package/vault-shim
source results/last_build.env
hab svc load $HAB_ORIGIN/vault-shim
```

Build and launch the application, and the run hook should provide the Vault server properties and secret configs to the Tomcat Server as System Properties. The application will then make use of the specific `role-id` and `secret-id` to retrive the secrets and handle the corresponding secret leases and renews, etc.

```
build examples/shim-package/national-parks
source results/last_build.env
hab svc load $HAB_ORIGIN/national-parks \
  --bind vault:vault-shim.default \
  --bind database:mongodb-parks.default
```

Now go to `http://localhost:8080/national-parks` to see the application running!

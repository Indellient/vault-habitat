# HashiCorp Vault and Chef Habitat Webinar

This repository holds the code for quickly deploying HashiCorp vault backed by
Consul running inside Chef Habitat.

## Dependencies

* Habitat
* Docker
* Test Kitchen
* Kitchen Docker
* Kitchen Habitat

## Usage

There are two use cases for this repository:

- Demos: quickly spin up the local cluster to display Vault/Consul/Habitat capabilities
- Development: Develop applications to make use of HashiCorp Vault

### Demo

#### Local Dev

To start from scratch (build and launch everything), ensure the dependencies are met, and then run the
following:

```
$ ./build.sh && ./launch.sh
```

##### Breakdown

The following builds the packages and create `last_build.env` files for each services:

```
$ ./build.sh
```

Will launch test kitchen setting the appropriate environment variables for the habitat packages
based on `last_build.env` files. The input should be 2 harts, the consul hart and the vault hart.

```
$ ./launch.sh
```

#### Terraform

All of the terraform is located in the `terraform/` directory. To launch it, you'll need to create a
variables file similar to the following:

```
# AWS
aws_key_name = "<key-name>"
aws_key_pair_file = "<path-to-key-file>"

# Network
vpc_id    = "<vpc-id>"    # default VPC
subnet_id = "<subnet-id>" # us-east-1

# Habitat variables
habitat_origin     = "<origin-name>"
habitat_auth_token = "<path-to-auth-token>"

# Tags
tag_environment = "<environment>"
tag_prefix      = "<prefix>"
```

With that built, you can now terraform:

```
$ cd terraform
$ terraform init
$ terraform plan -var-file <path to var file>
$ terraform apply -var-file <path to var file>
```

The terraform outputs will show you how to get the token as well as the vault address and various
UIs.

### Development

First, the packages need to be built. This can be easily done with habitat studio.

```
$ pushd consul
$ hab studio build
$ popd
$ pushd vault
$ hab studio build
```

Once this is completed, you can now run the kitchen code!

```
$ kitchen converge
```

To get the vault root token, grab it from the habitat census:

```
$ curl -s localhost:9631/census | jq -r '.["census_groups"]["vault.default"].service_config.value.config.token'
```

The Consul UI is now available here: `http://localhost:8200/ui`

The Vault UI is located here: `http://localhost:8500/ui`

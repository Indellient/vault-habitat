# HashiCorp Vault and Chef Habitat

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
$ hab pkg build .
$ popd
$ pushd vault
$ hab pkg build .
$ popd
```

Once this is completed, you can now run the kitchen code!

```
$ kitchen converge
```

To get the vault root token, grab it from the habitat census:

```
$ curl -s localhost:9631/census | jq -r '.["census_groups"]["vault.default"].service_config.value.token'
```

The Vault UI is now available here: `http://localhost:8200/ui`

The Consul UI is located here: `http://localhost:8500/ui`

# Application Examples

Two examples are included with this repository in the `examples/` folder that show two Habitat-Vault integration strategies, making use of a Java Web Application reading data from a database that is protected by a username and password.

The `cots-application` example application mimics a closed-source or third-party application without Vault integration that requires a username and password. We make use of Habitat to integrate this application with Vault transparently, see the `README` in the corresponding folder for more details.

The `shim-package` example modifies the Java application to integrate directly with vault, making use of AppRole authentication, now requiring system properties for the `secret-id` and `role-id` to be set. This example showcases how we make use of Habitat to integrate with a Non-Habitat Vault through the use of a `shim-package`. See the corresponding `README` for more information.

Note that there are in fact two different sets of patterns shown the above examples that can be combined as required:

|                      | Habitat Vault | Non-Habitat Vault |
| -------------------- | ------------- | ----------------- |
| Server Configuration | Configurations used to bootstrap Vault are exported through binds | Configurations to the Shim Package are exported through binds |
| Server Configuration Updates | Applications Automatically Reconfigure based on Vault Package configuration changes | Shim package must be reconfigured manually. Applications will reconfigure based on shim package's configuration. |

Looking at the table above we can see that while it is feasible to use a Non-Habitat Vault, some manual intervention is required and there is some room for error. As such, this approach is recommended when first experimenting with Habitat, or when first transitioning before all your applications - including vault - are brought over to the Habitat world.


|                      | Vault-Integrated Application | Non-Integrated Application |
| -------------------- | ---------------------------- | -------------------------------- |
| Secret Retrieval & Management | Handled by Application | Handled by Package Hooks |
| Awareness of Vault/Secrets | Application must make use of Vault properly | Application does not need to be aware of Vault, or secret configurations (location, etc.) |

Looking now at applications that are integrated with Vault as well as applications without direct integration, we see a much more subjective choice. Integrating an application directly with Vault may be more powerful in its interaction with other applications, and can allow you to make use of fully-fledged programming languages to handle secret management, leases and renewals. On the other hand, hooks can be transferrable between applications of different languages and can function without the application itself needing to be modified. This leads to a situation where either solution is viable depending on the developer's expertise, resources and the application-specific requirements.

In these examples, we show the use of a **Vault running in Habitat** with a application that is **not vault integrated**, as well as a **Non-Habitat Vault** with a **Vault-Integrated** Application. It is possible to make use of a Vault-Integrated application using a Vault Habitat Package, as well as using a non-integrated application with a shim package.

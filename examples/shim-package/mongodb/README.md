# MongoDB for National Parks

This Habitat plan describes how Mongo DB should be run to support the National Parks application. This differs from the `core/mongodb` plan in the following ways:

* Adds a dependency on `core/mongo-tools` to provide tools to the post-run hook, `hooks/post-run`.
* Copies the `national-parks.json` into the package that is later used to populated the database in the post-run hook, `hooks/post-run`.
* Adds username/password security and integrates with vault to grab the username and password as well as setup the database secret engine and configure it for the provisioned database. Will also export the role configured to read the database

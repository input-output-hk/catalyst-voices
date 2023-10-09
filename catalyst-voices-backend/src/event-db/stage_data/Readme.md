# Stage Specific Data

Subdirectories in this directory, that are named the same as a deployment stage will have their `.sql` files applied to the database when it is configured.

* `dev` - Development Environment specific data.
* `testnet` - Test-Net Environment specific data.
* `preprod` - Preprod Environment specific data.
* `prod` - Production Environment specific data.
* `local` - Local Testing Environment specific data.  Does not get checked in to git, local only.

Each directory can only contain `*.sql` files.
They will be applied in sorted order.

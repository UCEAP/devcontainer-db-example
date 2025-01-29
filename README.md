A MariaDB docker image with the UCEAP Drupal Example development seed data baked-in. Forked from https://github.com/UCEAP/devcontainer-db-generic

This needs the TERMINUS_TOKEN secret to be set in order to download the database backup from Pantheon.

When working locally you can set the TERMINUS_TOKEN environment variable and pass it to the build process as a secret like so:

``` sh
docker build -t myusername/devcontainer-db-example --secret id=TERMINUS_TOKEN .
```

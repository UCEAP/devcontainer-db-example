A MariaDB docker image with specific UCEAP Drupal development seed data baked-in.

This needs the TERMINUS_TOKEN secret to be set in order to download the database backup from Pantheon.

When working locally you can set the TERMINUS_TOKEN environment variable and pass it to the build process as a secret like so:

``` sh
docker build -t myusername/devcontainer-db-generic --secret id=TERMINUS_TOKEN .
```

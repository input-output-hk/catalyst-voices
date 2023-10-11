# Historic Data

This directory contains scripts and files related to Catalyst funds historic data.
Each directory is named after the fund it's related to.

## Scripts

Below is a description of the main scripts contained in each directory.

### mk_fundN_sql.py

Given a source SQLite3 database file, this is used to generate a SQL file containing statements
for inserting data into a database migrated using the new database schema.

### encrypt_fundN_sensitive_data.py

Given a source SQLite3 database file and a RSA 4096 public key,
this is used to generate a SQLite3 database file with sensitive data columns encrypted using the given public key.

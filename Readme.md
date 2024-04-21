# Readme

This bash script will export the password data from the [`pass`](https://www.passwordstore.org/) password manager into CSV
format.

## Requirements

`pass` needs to be installed and configured, the data will be extracted by calling `pass show`.

## Assumptions

In any given `pass` entry, the following is assumed:

- The password lives on line 1
- The username is preceded by "login:"
- The URL is preceded by "url:"
- The TOTP info contains the string "totp"

All additional content that is not matched in this list, will be transformed into a comma-separated list and included as
a separate field.

## Output format

Lines of the CSV file will have this format:

"title","username","password","notes/comments","url","totp-info"

Backslashes and double quotation marks in the password will be escaped with an additional preceding backslash.

## Config

The following environment variables are supported:

- `PASSWORD_STORE_DIR`: Location of the password store. Default is `$HOME/.password-store`.
- `PASSWORD_FILE`: Name of the output file. Default is `passwords.csv`.

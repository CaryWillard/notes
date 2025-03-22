#!/bin/bash

echo "gpg directions"
echo "(1) RSA and RSA"
echo "keysize: 4096"
echo "0, does not expire"
echo "y"
echo "real name: carywillard"
echo "email: "
echo "(O)kay"
echo "passphrase: root password"

gpg --full-generate-key

sudo apt install pass

pass init cary

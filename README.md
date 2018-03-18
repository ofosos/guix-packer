# Guix on AWS via Packer

This is a proof-of-concept. These are the necessary Packer and Shell
files to create custom Guix images for AWS.

# Running it

You can get packer at [packer.io](https://www.packer.io/).

You need a valid AWS configuration that packer can find. If you can
run `aws` commands you should be fine.

Create a file named `authorized_keys` in this directory and copy your
ssh public key there. Then run packer:

```
packer build packer.json
```

This will finish with a message that includes the generated AMI ID.

Spawn an instance and login as `alyssa` with your SSH key.

# Notes

 - Images built this way will not pick up any SSH keys you pass in via
   the AWS API.
 - Build time is around 15 minutes on t2.small, which is slow but ok.

# About

Copyright (c) 2018 - Mark Meyer

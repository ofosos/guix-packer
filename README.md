# Guix on AWS via Packer

This is a proof-of-concept. These are the necessary Packer and Shell
files to create custom Guix images for AWS.

# Running it

You can get packer at [packer.io](https://www.packer.io/).

You need a valid AWS configuration that packer can find. If you can
run `aws` commands you should be fine.

```
packer build guix-base.json
```

This will finish with a message that includes the generated AMI ID.

Spawn an instance and login as `alyssa` with the SSH key you defined
on the AWS console.

# Notes

 - Build time is around 15 minutes on t2.small, which is slow but ok.

# About

Copyright (c) 2018 - Mark Meyer

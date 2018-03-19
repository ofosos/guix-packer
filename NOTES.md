# Notes

## screengrabs

don't work from console

## logfiles

don't work from console

## shutdown via console

doesn't work, need to check acpi

## volume provisioning

could be done manually, then do `guix system reconfigure`

could be based on user-data, we could pass in a guix program as
user-data.

ignore for now

## PRNG seeding

One option is
(pollen)[http://blog.dustinkirkland.com/2014/02/random-seeds-in-ubuntu-1404-lts-cloud.html]

## on first boot

needs to deal with the following from the meta-data store
(`http://169.254.169.254/latest/`)

### ssh keys for `alyssa`

available as `meta-data/public-keys/0/openssh-key`

-> new service to pull those

### hostname

available as `meta-data/local-hostname`

this is an fqdn

### same ssh host key everywhere

needs to be regenerated, see gnu/services/ssh.scm

## enable ena (done)

There's driver for the Elastic Network Adapter on AWS:

(ENA on Github)[https://github.com/amzn/amzn-drivers/tree/master/kernel/linux/ena]

This is a GPL driver. It should be in upstream from at least 4.15 from
what I can see.

To enable in packer paste `"ena_support": true` into the builder.

## misc

See
(here)[https://github.com/ajacoutot/aws-openbsd/blob/master/ec2-init.sh]
for the OpenBSD way of doing things.

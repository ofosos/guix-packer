# Notes

## screengrabs

don't work from console

## logfiles

don't work from console

## volume provisioning

could be done manually, then do `guix system reconfigure`

could be based on user-data, we could pass in a guix program as
user-data.

## firstboot

needs to deal with the following from the meta-data store
(`http://169.254.169.254/latest/`)

### ssh keys for `alyssa`

available as `meta-data/public-keys/0/openssh-key`

### hostname

available as `meta-data/local-hostname`

### same ssh host key everywhere

needs to be regenerated

## misc

See
(here)[https://github.com/ajacoutot/aws-openbsd/blob/master/ec2-init.sh]
for the OpenBSD way of doing things.

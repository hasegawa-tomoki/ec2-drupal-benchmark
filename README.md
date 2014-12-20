# ec2-drupal-benchmark

## What is this?

Drupal setup scripts for benchmark on Amazon EC2 using Vagrant &amp; Chef.

## Tools installation & settings

1. Install [Virtualbox](https://www.virtualbox.org/wiki/Downloads).
2. Install [Vagrant](https://www.vagrantup.com/downloads).
3. Install Vagrant plugins vagrant-aws, vagrant-omnibus
4. Add this to your .bash_profile file.

```bash
export AWS_ACCESS_KEY_ID="(Access key id)"
export AWS_SECRET_ACCESS_KEY="(Secret access key)"
export AWS_SUBNET_ID="(subnet id)"
export AWS_PRIVATE_KEY_PATH="/path/to/privatekey.pem"
export AWS_KEYPAIR_NAME="(keypair name)"
```

Refs: [vagrant-aws configuration](https://github.com/mitchellh/vagrant-aws#configuration)

## Usage

### VM list

You can use this instance types.

```bash
$ vagrant status
Current machine states:

t2.micro                  not created (virtualbox)
t2.small                  not created (virtualbox)
t2.medium                 not created (virtualbox)
m3.medium                 not created (virtualbox)
m3.large                  not created (virtualbox)
m3.xlarge                 not created (virtualbox)
m3.2xlarge                not created (virtualbox)
c3.large                  not created (virtualbox)
c3.xlarge                 not created (virtualbox)
c3.2xlarge                not created (virtualbox)
c3.4xlarge                not created (virtualbox)
c3.8xlarge                not created (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

### Start instance

```bash
$ vagrant up t2.micro --provider=aws
```

Chef provision runs automatically. After this, you can use drupal.

### Stop & destroy instance

```bash
$ vagrant halt t2.micro
$ vagrant destroy t2.micro
```

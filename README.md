# make-secrets

A collection of GNU Make targets to generate secrets for seeding microservices,
intended to help automate the creation of ad-hoc test environments and platform
prototyping.

## Usage

This utility is built on GNU Make. To generate new data, specify a make target
in the desired directory. By default existing files will not be altered. To
force a file to be re-created, see Forcing Re-creation below.

### Random Strings (e.g. passwords)

Specify an arbitrary file name in the `string/` directory and a plaintext ASCII
file will be created containing a random alpha-numeric string.

```shell
make string/test-pwd
```

### SSH Keys

Specify an arbitrary file name in the `ssh/` directory with a suffix of either
`_rsa`, `_ecdsa`, or `_ed25519` and an SSH private key of the named type will
be created with a corresponding public key with a `.pub` extension.

#### Setting a Password

A password for the private key can be specified in an environment variable
named `MAKE_SSH_PASS`. The default is no password.

#### Configuring Bit-Length

For RSA and ECDSA a bit-length can be specified in an environment variable
named `MAKE_SSH_BITS`. The value will be ignored for ED25519 keys.

#### RSA

```shell
make ssh/user_rsa
```

```shell
# A leading space will prevent the shell from storing the command in history
 make MAKE_SSH_PASS=secret MAKE_SSH_BITS=8096 ssh/user_rsa
```

Default value for `MAKE_SSH_BITS` is `4096`.


#### ECDSA

```shell
make ssh/user_ecdsa
```

Default value for `MAKE_SSH_BITS` is `384`.

#### ED25519

```shell
make ssh/user_ed25519
```

`MAKE_SSH_BITS` is ignored.

#### SSH Key with Auto-Generated Password

An example showing the use of both an environment variable and a make variable,
as well as auto-generating the password with a `string/` target.

```
make string/sshpass
export MAKE_SSH_BITS=521
make ssh/user_ecdsa MAKE_SSH_PASS=$(< string/sshpass)
```

### Self-Signed x509 Certificates

Create a self-signed x509 certificate pair with V3 CA extensions by specifying
an arbitrary path under the `self-signed/` directory. A subdirectory will be
created with two files: `private.pem` and `public.pem`. The certificate subject
is localhost, and the name of the file itself is added as an alternate name.

```shell
make self-signed/example.local
```

### Forcing Re-creation

To force Make to re-create an existing file, pass the option `-B`.

```shell
make -B $TARGET
```


STRING_LENGTH ?= 77
string/%:
	@head -c $(STRING_LENGTH) /dev/urandom | tr -dc '[:alnum:]' > $@
	@echo >> $@


MAKE_SSH_PASS ?= ''
ssh/%_rsa: MAKE_SSH_BITS ?= 4096
ssh/%_rsa:
	@ssh-keygen -t rsa -b $(MAKE_SSH_BITS) -N $(MAKE_SSH_PASS) -f $@
ssh/%_ecdsa: MAKE_SSH_BITS ?= 384
ssh/%_ecdsa:
	@ssh-keygen -t ecdsa -b $(MAKE_SSH_BITS) -N $(MAKE_SSH_PASS) -f $@
ssh/%_ed25519:
	@ssh-keygen -t ed25519 -N $(SSH_PASS) -f $@


self-signed/% self-signed/%/public.pem self-signed/%/private.pem:
	@mkdir -p self-signed/$*
	@openssl req -x509 -newkey rsa:4096 -sha384 -nodes -days 711 \
		-subj '/CN=localhost' \
		-addext "subjectAltName=IP:127.0.0.1,DNS:$*" \
		-extensions v3_ca \
		-keyout self-signed/$*/private.pem \
		-out self-signed/$*/public.pem


-- letsencrypt-postfix-dovecot-installer
-- Version: 					0.1
-- Dependency:				PyroAPI
-- Dependency version:	1.2

local api = require "PyroAPI"

local domain = api.get_input("Please enter your domain: ")

local commands = {}

commands[#commands+1] = "openssl genrsa -des3 -out pyro.key"
commands[#commands+1] = "chmod 600 pyro.key"
commands[#commands+1] = "openssl req -new -key pyro.key -out pyro.csr"
commands[#commands+1] = "openssl x509 -req -days 365 -in pyro.csr -signkey pyro.key -out pyro.crt"
commands[#commands+1] = "openssl rsa -in pyro.key -out pyro.key.nopass"
commands[#commands+1] = "mv pyro.key.nopass pyro.key"
commands[#commands+1] = "openssl req -new -x509 -extensions v3_ca -keyout cakey.pem -out cacert.pem -days 365"
commands[#commands+1] = "chmod 600 pyro.key"
commands[#commands+1] = "chmod 600 cakey.pem"
commands[#commands+1] = "mv pyro.key /etc/ssl/private/"
commands[#commands+1] = "mv pyro.crt /etc/ssl/certs/"
commands[#commands+1] = "mv cakey.pem /etc/ssl/private/"
commands[#commands+1] = "mv cacert.pem /etc/ssl/certs/"
commands[#commands+1] = "postconf -e \"myhostname = " .. domain .. "\""
commands[#commands+1] = "postconf -e \"mydomain = " .. domain .. "\""
commands[#commands+1] = "postconf -e \"myorigin = " .. domain .. "\""
commands[#commands+1] = "postconf -e \"home_mailbox = Maildir/\""
commands[#commands+1] = "postconf -e \"mailbox_command = \""
commands[#commands+1] = "postconf -e \"smtpd_sasl_type = dovecot\""
commands[#commands+1] = "postconf -e \"smptd_sasl_path = private/auth\""
commands[#commands+1] = "postconf -e \"smptd_sasl_auth_enable = yes\""
commands[#commands+1] = "postconf -e \"smtpd_tls_auth_only = no\""
commands[#commands+1] = "postconf -e \"smtpd_use_tls = yes\""
commands[#commands+1] = "postconf -e \"smtp_use_tls = yes\""
commands[#commands+1] = "postconf -e \"smtp_tls_note_starttls_offer = yes\""
commands[#commands+1] = "postconf -e \"smptd_tls_key_file = /etc/ssl/private/pyro.key\""
commands[#commands+1] = "postconf -e \"smptd_tls_cert_file = /etc/ssl/certs/pyro.crt\""
commands[#commands+1] = "postconf -e \"smptd_tls_CAfile = /etc/ssl/certs/cacert.pem\""
commands[#commands+1] = "postconf -e \"smptd_tls_loglevel = 1\""
commands[#commands+1] = "postconf -e \"smptd_tls_received_header = yes\""
commands[#commands+1] = "postconf -e \"smptd_tls_session_cache_timeout = 3600s\""
commands[#commands+1] = "service postfix restart"
commands[#commands+1] = "apt-get install -y dovecot-common dovecot-imapd"

for i = 1, #commands do
	os.execute(commands[i])
end
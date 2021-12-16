#!/bin/bash
set -e

# Usage
# ./initial-setup.sh $HOSTNAME
# e.g. ./initial-setup.sh sweetstackhq.com
#
# LetsEncrypt will get SSL cert for $HOSTNAME and www.$HOSTNAME

# Hostname

HOSTNAME=$1
ADMIN_USERNAME=pietrorea
ADMIN_GROUP_NAME=sweetstackadmin
APP_USERNAME=sweetstacker
APP_GROUP_NAME=sweetstack
PROJECT_NAME=sweetstack

NODE_VERSION=v14.17.6
NODE_URL=https://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION-linux-x64.tar.gz

if [[ "$EUID" -ne 0 ]]; then
  echo "Error: Please run as root with sudo."
  exit
fi

if [ -z "$HOSTNAME" ]; then
  echo "Error: Pass in the hostname as the first parameter."
  exit
fi

echo "$HOSTNAME" > /etc/hostname
hostname -F /etc/hostname

# Add admin user

useradd -s /bin/bash -m $ADMIN_USERNAME
cd /home/$ADMIN_USERNAME
mkdir -p .ssh
cat > .ssh/authorized_keys << "EOF"
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+2LJeEVgiWhVxs3gWqQcfA/M5W/PLzL40AnRFmQ6RQIiKoKXZY6uLt2lDrHzrCzcaYZJCihKhIbTfTVRZyOTHq8ReZefYZuCf6Pq0qPSO17LKIDViCG7KWObz0anwQISLbl3jFXBJmQn47WsO2u+d+j9lrhERN0jqATkZA3C8H6/1seJpehG7bHMVp2yVTUrPbl33fpDt7IX7MQAb23AykLrg+MoCzjRAOQgo7budo76abpA8pIYwVXBOh3dachSwG+IowC6KyhAWS92EZjakuCcQybU4zrO4X9QgyfFdfoU+LDpztgiqH7breqhG/9Z/SYcpi445KF1d6p4JJevcjhAOrDACRAeQqD2rU3TjfATkaAHzTQwIuaD25h143ZfIT8tcn5K0sZAiG60Y7o8joSAqg4ypDAidN6nARF6Sg0Ure7kGXGvoRLnqu+ZUzi1ILCFHIh9e+UgFINE+ayLa/41atIpo4mUWSWsrRxTNzcddGtodFau480ukooElKtGE1JcXWGHRw5QM7tTrp1SdlHVJQHSE1h3Esq6OCEtBzKqyto8XIHpVq7+X7kgIdr0qANiS4kuTnGKSINdyxUIg+C6+28l6KBPRVChvx8bIaX4YDSuXTtduW9mxIO1PH1jKtdckFVW1uO5xUhzcLfymbAu1xx4lvMgwAgsH7I8How== pietro@sweetpeamobile.com

EOF
chmod 700 .ssh
chmod 600 .ssh/authorized_keys
chown -R $ADMIN_USERNAME:$ADMIN_USERNAME .ssh

# Add application-level user

useradd -s /bin/bash -m $APP_USERNAME
cd /home/$APP_USERNAME
mkdir -p .ssh
cat > .ssh/authorized_keys << "EOF"
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+2LJeEVgiWhVxs3gWqQcfA/M5W/PLzL40AnRFmQ6RQIiKoKXZY6uLt2lDrHzrCzcaYZJCihKhIbTfTVRZyOTHq8ReZefYZuCf6Pq0qPSO17LKIDViCG7KWObz0anwQISLbl3jFXBJmQn47WsO2u+d+j9lrhERN0jqATkZA3C8H6/1seJpehG7bHMVp2yVTUrPbl33fpDt7IX7MQAb23AykLrg+MoCzjRAOQgo7budo76abpA8pIYwVXBOh3dachSwG+IowC6KyhAWS92EZjakuCcQybU4zrO4X9QgyfFdfoU+LDpztgiqH7breqhG/9Z/SYcpi445KF1d6p4JJevcjhAOrDACRAeQqD2rU3TjfATkaAHzTQwIuaD25h143ZfIT8tcn5K0sZAiG60Y7o8joSAqg4ypDAidN6nARF6Sg0Ure7kGXGvoRLnqu+ZUzi1ILCFHIh9e+UgFINE+ayLa/41atIpo4mUWSWsrRxTNzcddGtodFau480ukooElKtGE1JcXWGHRw5QM7tTrp1SdlHVJQHSE1h3Esq6OCEtBzKqyto8XIHpVq7+X7kgIdr0qANiS4kuTnGKSINdyxUIg+C6+28l6KBPRVChvx8bIaX4YDSuXTtduW9mxIO1PH1jKtdckFVW1uO5xUhzcLfymbAu1xx4lvMgwAgsH7I8How== pietro@sweetpeamobile.com
EOF
chmod 700 .ssh
chmod 600 .ssh/authorized_keys
chown -R $APP_USERNAME:$APP_USERNAME .ssh

# Create admin group

groupadd $ADMIN_GROUP_NAME --system -f
usermod -aG $ADMIN_GROUP_NAME $ADMIN_USERNAME

cat > /etc/sudoers.d/$PROJECT_NAME << "EOF"
%sweetstackadmin ALL=(ALL) NOPASSWD:ALL
EOF
chmod 0440 /etc/sudoers.d/$PROJECT_NAME
visudo -c

# SSH setup

cat > /etc/ssh/sshd_config << "EOF"
#	$OpenBSD: sshd_config,v 1.103 2018/04/09 20:41:22 tj Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/bin:/bin:/usr/sbin:/sbin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

Include /etc/ssh/sshd_config.d/*.conf

#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

#HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key
#HostKey /etc/ssh/ssh_host_ed25519_key

# Ciphers and keying
#RekeyLimit default none

# Logging
#SyslogFacility AUTH
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
#PermitRootLogin prohibit-password
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

#PubkeyAuthentication yes

# Expect .ssh/authorized_keys2 to be disregarded by default in future.
#AuthorizedKeysFile	.ssh/authorized_keys .ssh/authorized_keys2

#AuthorizedPrincipalsFile none

#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to no here!
PasswordAuthentication no
#PermitEmptyPasswords no

# Change to yes to enable challenge-response passwords (beware issues with
# some PAM modules and threads)
ChallengeResponseAuthentication no

# Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no

# GSSAPI options
#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes
#GSSAPIStrictAcceptorCheck yes
#GSSAPIKeyExchange no

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the ChallengeResponseAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via ChallengeResponseAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and ChallengeResponseAuthentication to 'no'.
UsePAM yes

#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts no
X11Forwarding yes
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
PrintMotd no
#PrintLastLog yes
#TCPKeepAlive yes
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#UseDNS no
#PidFile /var/run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none

# no default banner path
#Banner none

# Allow client to pass locale environment variables
AcceptEnv LANG LC_*

# override default of no subsystems
Subsystem	sftp	/usr/lib/openssh/sftp-server

# Example of overriding settings on a per-user basis
#Match User anoncvs
#	X11Forwarding no
#	AllowTcpForwarding no
#	PermitTTY no
#	ForceCommand cvs server

TrustedUserCAKeys /etc/ssh/lightsail_instance_ca.pub
CASignatureAlgorithms +ssh-rsa
EOF

service sshd restart

## Ubuntu updates and deps

apt-get update
apt-get -y upgrade
apt-get -y autoremove

apt-get install -y nginx git mysql-server

# Lets Encrypt
snap install core
snap refresh core
apt-get remove certbot
snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot
certbot certonly --nginx -d $HOSTNAME

# Lets Encrupt - Comment out if you don't need www.
certbot certonly --nginx -d www.$HOSTNAME

# nginx stup

cat > /etc/nginx/sites-available/$HOSTNAME << "EOF"
resolver 8.8.8.8 8.8.4.4;

server {
	# HTTP redirect
	listen 80;
	return 301 https://$host$request_uri;
}

server {
	# SSL configuration
	listen 443 ssl default_server;

  server_name sweetstackhq.com;
  
  ssl_certificate /etc/letsencrypt/live/sweetstackhq.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/sweetstackhq.com/privkey.pem;
	ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
	
  include /etc/letsencrypt/options-ssl-nginx.conf; 	

  # Redirects
  rewrite ^/menu$ /auth/guest permanent;

  # Static files (all purpose)
	location ~ ^/(images/|static/|apple-app-site-association) {
		root /home/sweetstacker/sweetstackhq.com/static;
    location ~ "^/static/" {
      default_type application/json;
    }

    location ~ "^/apple-app-site-association$" {
      default_type application/json;
    }
	}

  # Marketing site API
  location ~* ^/(site/api/) {
    proxy_pass http://127.0.0.1:9091;
  }


  # Node API & SPAs
  location ~* ^/(api/|auth/|dashboard/|app/|dist/) {
    proxy_pass http://127.0.0.1:9092;
  }

  # Marketing website
  location / {
    root /home/sweetstacker/sweetstackhq.com/static/www;
    index index.html;
    error_page 404 /;
	}

  # Static files associated with marketing website
  location ~* \.(js|jpg|png|css|svg|otf)$ {
    root /home/sweetstacker/sweetstackhq.com/static/www;
    try_files $uri =404;
  }
}
EOF

rm -f /etc/nginx/sites-enabled/default
ln -sf /etc/nginx/sites-available/$HOSTNAME /etc/nginx/sites-enabled/
service nginx reload

## Install Node.js

curl $NODE_URL | tar -xzf - -C /usr/local/lib/
ln -sfn /usr/local/lib/node-$NODE_VERSION-linux-x64 /usr/local/lib/node

cat > /home/$APP_USERNAME/.profile << "EOF"
# Default ~/.profile - Unchanged by setup script.
#
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

## NodeJS
export PATH=/usr/local/lib/node/bin:$PATH
EOF
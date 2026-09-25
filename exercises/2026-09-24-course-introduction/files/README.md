# LFCS Focus — M. Boiguillé

**M Boiguillé — Linux System Administrator**

## Objective

Build practical Linux administration skills through hands-on exercises and real-world troubleshooting scenarios, with a focus on understanding how systems work rather than memorizing commands.

**Status:** In progress
**Target:** LFCS Certification

## Current Focus

For this LFCS preparation cycle, I'll study this areas:

- Essential Commands
- Operations Deployment
- Users and Groups
- Networking
- Storage

```bash
    wget -q https://notes.kodekloud.com/llms.txt
```

## Environnement

uid=0(root) gid=0(root) groups=0(root)
PRETTY_NAME="Ubuntu 22.04.5 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.5 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="<https://www.ubuntu.com/>"
SUPPORT_URL="<https://help.ubuntu.com/>"
BUG_REPORT_URL="<https://bugs.launchpad.net/ubuntu/>"

## Packages Installed

adduser
apt
base-files
base-passwd
bash
bsdutils
coreutils
curl
dash
debconf
debianutils
diffutils
dpkg
e2fsprogs
findutils
gcc-12-base
git
gpgv
grep
gzip
hostname
init-system-helpers
libacl1
libapt-pkg6.0
libattr1
libaudit-common
libaudit1
libblkid1
libbz2-1.0
libc-bin
libc6
libcap-ng0
libcap2
libcom-err2
libcrypt1
libdb5.3
libdebconfclient0
libext2fs2
libffi8
libgcc-s1
libgcrypt20
libgmp10
libgnutls30
libgpg-error0
libgssapi-krb5-2
libhogweed6
libidn2-0
libk5crypto3
libkeyutils1
libkrb5-3
libkrb5support0
liblz4-1
liblzma5
libmount1
libncurses6
libncursesw6
libnettle8
libnsl2
libp11-kit0
libpam-modules
libpam-modules-bin
libpam-runtime
libpam0g
libpcre2-8-0
libpcre3
libprocps8
libseccomp2
libselinux1
libsemanage-common
libsemanage2
libsepol2
libsmartcols1
libss2
libssl3
libstdc++6
libsystemd0
libtasn1-6
libtinfo6
libtirpc-common
libtirpc3
libudev1
libunistring2
libuuid1
libxxhash0
libzstd1
login
logsave
lsb-base
mawk
mount
ncurses-base
ncurses-bin
openssh-server
passwd
perl-base
procps
sed
sensible-utils
sudo
sysvinit-utils
tar
ubuntu-keyring
ufw
usrmerge
util-linux
vim
wget
zlib1g

## Scenario Logs

```docker
server-1  | [chaos 14:53:01] nouveau scénario: ufw_block
server-1  | [chaos 14:53:01] blocage du port 22 par ufw
server-1  | [chaos 14:53:02] panne 'ufw_block' en place — répare puis lance 'make chaos-next'
server-1  | [chaos 15:04:31] signal reçu ('make chaos-next')
server-1  | [chaos 15:04:31] ouverture du port 22 et désactivation de ufw
server-1  | [chaos 15:04:35] nouveau scénario: stop_sshd
server-1  | [chaos 15:04:35] arrêt de sshd
server-1  | [chaos 15:04:35] panne 'stop_sshd' en place — répare puis lance 'make chaos-next'
server-1  | [chaos 15:05:45] signal reçu ('make chaos-next')
server-1  | [chaos 15:05:45] redémarrage de sshd
server-1  | [chaos 15:05:48] nouveau scénario: stop_sshd
server-1  | [chaos 15:05:48] arrêt de sshd
server-1  | [chaos 15:05:48] panne 'stop_sshd' en place — répare puis lance 'make chaos-next'
server-1  | [chaos 15:07:10] signal reçu ('make chaos-next')
server-1  | [chaos 15:07:10] redémarrage de sshd
server-1  | [chaos 15:07:13] nouveau scénario: stop_sshd
server-1  | [chaos 15:07:13] arrêt de sshd
server-1  | [chaos 15:07:13] panne 'stop_sshd' en place — répare puis lance 'make chaos-next'
server-1  | [chaos 15:09:02] signal reçu ('make chaos-next')
server-1  | [chaos 15:09:02] redémarrage de sshd
server-1  | [chaos 15:09:05] nouveau scénario: change_port
server-1  | [chaos 15:09:05] changement du port SSH: 22 -> 2222
server-1  | [chaos 15:09:05] panne 'change_port' en place — répare puis lance 'make chaos-next'
```

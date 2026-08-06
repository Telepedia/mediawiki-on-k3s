# New users start at uid 3000, new groups at gid 7000, to avoid collisions
users:
  originalauthority:
    fullname: Original Authority
    ssh-keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILD0e5CCa8BhhAmKvIHPjhN6+dMU0uQ1Z/ZHcfmqoUVP original.authority0@gmail.com
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJCx8HDPz/+BFgxgsRZaSlz96iTrNpIv4UbA/vpRBTUA luke@telepedia.net
    uid: 3000
    gid: 3000

groups:
  ops:
    gid: 7000
    description: root, everywhere
    members: [originalauthority]
    privileges: ['ALL = (ALL) NOPASSWD: ALL']
  mediawiki-admins:
    gid: 7001
    description: sudo on MediaWiki servers
    members: []
    privileges: ['ALL = (www-data) NOPASSWD: ALL',
            'ALL = (ALL) NOPASSWD: /usr/sbin/service nginx *',
            'ALL = (ALL) NOPASSWD: /usr/sbin/service php8.2-fpm *',
            'ALL = (ALL) NOPASSWD: /usr/bin/journalctl *']

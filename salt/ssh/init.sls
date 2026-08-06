/etc/ssh/sshd_config.d/00-telepedia-hardening.conf:
  file.managed:
    - contents: |
        PasswordAuthentication no
        PermitRootLogin prohibit-password
        PubkeyAuthentication yes
    - mode: '0644'
    - user: root
    - group: root

# we validate the full config before reloading so that if it fails we are not left
# locked out or with SSH in a borked state
reload_sshd:
  cmd.run:
    - name: /usr/sbin/sshd -t && systemctl reload ssh
    - onchanges:
      - file: /etc/ssh/sshd_config.d/00-telepedia-hardening.conf

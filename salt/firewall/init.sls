nftables_pkg:
  pkg.installed:
    - name: nftables

# stop the stock nftables from running as it would wipe out k3s networking
mask_stock_nftables:
  service.masked:
    - name: nftables
    - require:
      - pkg: nftables_pkg

# drop 3306 traffic (mariaDB; it shouldn't be an issue since its on a private VLAN but alas
# better to be safe than sorry!)
/etc/nftables.d/telepedia.nft:
  file.managed:
    - makedirs: True
    - mode: '0644'
    - user: root
    - group: root
    - contents: |
        #!/usr/sbin/nft -f
        table inet telepedia_fw
        delete table inet telepedia_fw
        table inet telepedia_fw {
          chain input {
            type filter hook input priority filter; policy accept;
            tcp dport 3306 ip saddr { 127.0.0.1, 10.42.0.0/16, 159.195.111.69 } accept
            tcp dport 3306 drop
          }
        }

/etc/systemd/system/telepedia-nft.service:
  file.managed:
    - mode: '0644'
    - user: root
    - group: root
    - contents: |
        [Unit]
        Description=Telepedia nftables rules
        After=k3s.service
        Wants=k3s.service

        [Service]
        Type=oneshot
        RemainAfterExit=yes
        ExecStart=/usr/sbin/nft -f /etc/nftables.d/telepedia.nft

        [Install]
        WantedBy=multi-user.target

nft_daemon_reload:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/telepedia-nft.service

telepedia_nft_service:
  service.running:
    - name: telepedia-nft
    - enable: True
    - require:
      - pkg: nftables_pkg
      - file: /etc/nftables.d/telepedia.nft
      - file: /etc/systemd/system/telepedia-nft.service
    - watch:
      - file: /etc/nftables.d/telepedia.nft

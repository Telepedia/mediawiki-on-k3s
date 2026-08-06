mariadb_packages:
  pkg.installed:
    - pkgs:
      - mariadb-server
      - mariadb-client

# server_id must be unique per DB host we set othello as 2 as the existing Hetzner database is already
# 1 and to bring over the databases we'll replicate them so they need to be different
/etc/mysql/mariadb.conf.d/60-telepedia.cnf:
  file.managed:
    - mode: '0644'
    - user: root
    - group: root
    - require:
      - pkg: mariadb_packages
    - contents: |
        [mariadb]
        bind-address                    = {{ salt['pillar.get']('vlan_ip', '127.0.0.1') }}
        log_bin                         = mariadb-bin
        server_id                       = 2
        binlog_format                   = ROW
        sync_binlog                     = 1
        log_slave_updates               = ON
        expire_logs_days                = 14
        max_binlog_size                 = 256M
        log_bin_trust_function_creators = 1

mariadb_service:
  service.running:
    - name: mariadb
    - enable: True
    - require:
      - pkg: mariadb_packages
    - watch:
      - file: /etc/mysql/mariadb.conf.d/60-telepedia.cnf

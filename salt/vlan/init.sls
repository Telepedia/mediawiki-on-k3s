{% set vlan_ip = salt['pillar.get']('vlan_ip') %}
{% if vlan_ip %}
/etc/network/interfaces.d/60-vlan.cfg:
  file.managed:
    - mode: '0644'
    - user: root
    - group: root
    - contents: |
        auto eth1
        iface eth1 inet static
            address {{ vlan_ip }}
            netmask 255.255.255.0
            mtu 1400

vlan_ifup:
  cmd.run:
    - name: ifup eth1
    - unless: ip -o addr show eth1 | grep -q '{{ vlan_ip }}'
    - require:
      - file: /etc/network/interfaces.d/60-vlan.cfg
{% endif %}

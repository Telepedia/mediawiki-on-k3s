base:
  '*':
    - users
    - ssh
  'roles:k3s-server':
    - match: grain
    - vlan
    - firewall
    - k3s
    - mariadb

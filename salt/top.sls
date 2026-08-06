base:
  '*':
    - users
    - ssh
  'roles:k3s-server':
    - match: grain
    - k3s
    - mariadb

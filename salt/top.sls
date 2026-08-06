base:
  '*':
    - users
  'roles:k3s-server':
    - match: grain
    - k3s

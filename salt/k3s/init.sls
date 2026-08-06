k3s_install:
  cmd.run:
    - name: >
        curl -sfL https://get.k3s.io |
        INSTALL_K3S_EXEC="server --disable traefik --secrets-encryption --write-kubeconfig-mode 0644 --tls-san othello.telepedia.internal"
        sh -
    - unless: test -x /usr/local/bin/k3s
    - require:
      - pkg: k3s_prereqs

k3s_prereqs:
  pkg.installed:
    - names:
      - curl

k3s_service:
  service.running:
    - name: k3s
    - enable: true
    - require:
      - cmd: k3s_install

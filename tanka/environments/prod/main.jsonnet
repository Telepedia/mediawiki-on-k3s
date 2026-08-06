local k = import 'github.com/jsonnet-libs/k8s-libsonnet/1.35/main.libsonnet';

// Just a test to see if this actually works hehe!
{
  smoke: k.apps.v1.deployment.new(
    'smoke', 1, [k.core.v1.container.new('nginx', 'nginx:stable')]
  ),
}

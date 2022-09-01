virtual_instance_id="dxp.localdev.me"

watch_file('k8s/dxp_endpoint/')
watch_file('k8s/extension/')
watch_file('k8s/extension_job/')

k8s_yaml(local(["k8s/dxp_endpoint/yaml.sh", virtual_instance_id]))

k8s_resource(
  labels=['dxp-proxy'],
  objects=[
    'dxp-proxy:endpoints',
    'dxp-proxy:ingress',
    'dxp-proxy:ingressroute',
    'dxp-proxy:service'
   ],
   new_name='dxp-proxy'
)

# Extensions

def process_extension(
    name, source_deps = [], objects = [], port_forwards = [], resource_deps = []):
  custom_build(
    name,
    'extensions/%s/build.sh' % name,
    deps=['extensions/%s/src' % name] + source_deps,
    ignore=[]
  )

  k8s_yaml(local(["extensions/%s/yaml.sh" % name, virtual_instance_id]))
  watch_file('extensions/%s/%s.client-extension-config.json' % (name, name))
  watch_file('extensions/%s/yaml.sh' % name)

  k8s_resource(
    labels=['extensions'],
    port_forwards=port_forwards,
    objects=['%s-%s-lxc-ext-provision-metadata:configmap' % (name, virtual_instance_id)] + objects,
    resource_deps=resource_deps,
    workload=name
  )

# coupondfn
process_extension(
  name='coupondfn')

# coupondata
process_extension(
  name='coupondata',
  resource_deps=['coupondfn'])

# couponpdf
process_extension(
  name='couponpdf',
  source_deps=[
    'extensions/couponpdf/pom.xml'
  ], 
  objects=[
    'couponpdf:ingress',
    'couponpdf:ingressroute'
  ],
  port_forwards=['8001'],
  resource_deps=['coupondfn'])

# uscities
process_extension(
  name='uscities',
  source_deps=[
    'extensions/uscities/pom.xml'
  ],
  objects=[
    'uscities:ingress',
    'uscities:ingressroute'
  ],
  port_forwards=['8002'])

update_settings(max_parallel_updates=1)
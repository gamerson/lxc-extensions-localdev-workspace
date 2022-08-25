watch_file('k8s/dxp_endpoint/')
watch_file('k8s/extension/')
watch_file('k8s/extension_job/')

k8s_yaml(local("k8s/dxp_endpoint/yaml.sh"))

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

# coupondfn
custom_build(
  'coupondfn',
  "extensions/coupondfn/build.sh",
  deps=[
    'extensions/coupondfn/src'
  ],
  ignore=[]
)

k8s_yaml(local("extensions/coupondfn/yaml.sh"))
watch_file('extensions/coupondfn/coupondfn.client-extension-config.json')
watch_file('extensions/coupondfn/yaml.sh')

k8s_resource(
  labels=['extensions'],
  objects=[
    'coupondfn-liferay.com-lxc-ext-provision-metadata:configmap'
  ],
  workload='coupondfn'
)

# coupondata
custom_build(
  'coupondata',
  "extensions/coupondata/build.sh",
  deps=[
    'extensions/coupondata/src'
  ],
  ignore=[]
)

k8s_yaml(local("extensions/coupondata/yaml.sh"))
watch_file('extensions/coupondata/coupondata.client-extension-config.json')
watch_file('extensions/coupondata/yaml.sh')

k8s_resource(
  labels=['extensions'],
  objects=[
    'coupondata-liferay.com-lxc-ext-provision-metadata:configmap'
  ],
  resource_deps=['coupondfn'],
  workload='coupondata'
)

# couponpdf
custom_build(
  'couponpdf', 
  "extensions/couponpdf/build.sh",
  deps=[
    'extensions/couponpdf/src',
    'extensions/couponpdf/pom.xml'
  ], 
  ignore=[]
)

k8s_yaml(local("extensions/couponpdf/yaml.sh"))
watch_file("extensions/couponpdf/couponpdf.client-extension-config.json")
watch_file("extensions/couponpdf/yaml.sh")

k8s_resource(
  labels=['extensions'],
  port_forwards=['8001'],
  objects=[
    'couponpdf-liferay.com-lxc-ext-provision-metadata:configmap', 
    'couponpdf:ingress',
    'couponpdf:ingressroute'
  ],
  resource_deps=['coupondfn'],
  workload='couponpdf'
)

# uscities
custom_build(
  'uscities', 
  "extensions/uscities/build.sh",
  deps=[
    'extensions/uscities/src',
    'extensions/uscities/pom.xml'
  ], 
  ignore=[]
)

k8s_yaml(local("extensions/uscities/yaml.sh"))
watch_file("extensions/uscities/uscities.client-extension-config.json")
watch_file("extensions/uscities/yaml.sh")

k8s_resource(
  labels=['extensions'],
  port_forwards=['8002'],
  objects=[
    'uscities-liferay.com-lxc-ext-provision-metadata:configmap', 
    'uscities:ingress',
    'uscities:ingressroute'
  ],
  workload='uscities'
)

update_settings(max_parallel_updates=1)
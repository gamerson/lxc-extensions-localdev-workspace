# watch yaml template directories
watch_file('k8s/dxp/')
watch_file('k8s/extension/')

# DXP
custom_build(
  'dxp', 
  "./gradlew :cleanDockerImage :buildDockerImage -Pdocker.image.id=$EXPECTED_REF", 
  deps=[
    'build.gradle',
    'configs/',
    'gradle.properties',
    'settings.gradle'
  ],
  ignore=[]
)

k8s_yaml(
  local(
    """ytt \
      -f k8s/dxp  \
      --data-value image=dxp"""
  )
)

k8s_resource(
  labels=['dxp'],
  port_forwards=['8000'],
  objects=[
    'dxp:ingress',
    'dxp:ingressroute',
    'dxp-data:persistentvolume',
    'dxp-data:persistentvolumeclaim'
   ],
   workload='dxp'
)

# Extensions

# able-theme-css
custom_build(
  'able-theme-css',
  "extensions/able-theme-css/build.sh",
  deps=[
    'extensions/able-theme-css/build.gradle',
    'extensions/able-theme-css/client-extension.yaml',
    'extensions/able-theme-css/package.json',
    'extensions/able-theme-css/src'
  ],
  ignore=[]
)

k8s_yaml(local("extensions/able-theme-css/yaml.sh"))

watch_file("extensions/able-theme-css/client-extension.yaml")
watch_file("extensions/able-theme-css/yaml.sh")

k8s_resource(
  labels=['extensions'],
  resource_deps=['dxp'],
  objects=[
    'able-theme-css-liferay.com-lxc-ext-provision-metadata:configmap',
    'able-theme-css:ingress',
    'able-theme-css:ingressroute'
  ],
  workload='able-theme-css'
)

# city-search
custom_build(
  'city-search',
  "extensions/city-search/build.sh",
  deps=[
    'extensions/city-search/build.gradle',
    'extensions/city-search/client-extension.yaml',
    'extensions/city-search/package.json',
    'extensions/city-search/src'
  ],
  ignore=[]
)

k8s_yaml(local("extensions/city-search/yaml.sh"))
watch_file("extensions/city-search/yaml.sh")

k8s_resource(
   labels=['extensions'],
   resource_deps=['dxp'],
   objects=[
    'city-search-liferay.com-lxc-ext-provision-metadata:configmap',
    'city-search:ingress',
    'city-search:ingressroute'
  ],
   workload='city-search'
)

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
  resource_deps=['dxp'],
  objects=[
    'coupondfn-liferay.com-lxc-ext-provision-metadata:configmap'
  ],
  workload='coupondfn'
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
  resource_deps=['dxp', 'coupondfn'],
  objects=[
    'couponpdf-liferay.com-lxc-ext-provision-metadata:configmap', 
    'couponpdf:ingress',
    'couponpdf:ingressroute'
  ],
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
  resource_deps=['dxp'],
  objects=[
    'uscities-liferay.com-lxc-ext-provision-metadata:configmap', 
    'uscities:ingress',
    'uscities:ingressroute'
  ],
  workload='uscities'
)

update_settings(max_parallel_updates=1)
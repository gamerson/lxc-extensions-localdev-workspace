# DXP
custom_build(
  'dxp', 
  "./gradlew clean buildDockerImage -Pdocker.image.id=$EXPECTED_REF", 
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
    'liferay.com-lxc-dxp-metadata:configmap',
    'dxp:ingress',
    'dxp:ingressroute'
   ],
   workload='dxp'
)

# Extensions

# able-theme-css
custom_build(
  'able-theme-css',
  "extensions/able-theme-css/tilt_build.sh",
  deps=[
    'extensions/able-theme-css/build.gradle',
    'extensions/able-theme-css/client-extension.yaml',
    'extensions/able-theme-css/package.json',
    'extensions/able-theme-css/src'
  ],
  ignore=[]
)

k8s_yaml(local("extensions/able-theme-css/tilt_yaml.sh"))

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

# couponpdf
custom_build(
  'couponpdf', 
  "extensions/couponpdf/tilt_build.sh",
  deps=[
    'extensions/couponpdf/configurator',
    'extensions/couponpdf/src',
    'extensions/couponpdf/pom.xml'
  ], 
  ignore=[]
)

k8s_yaml(local("extensions/couponpdf/tilt_yaml.sh"))

k8s_resource(
   labels=['extensions'],
   port_forwards=['8001'],
   resource_deps=['dxp'],
   objects=[
    'couponpdf-liferay.com-lxc-ext-provision-metadata:configmap', 
    'couponpdf:ingress',
    'couponpdf:ingressroute'
  ],
   workload='couponpdf'
)

update_settings(max_parallel_updates=1)
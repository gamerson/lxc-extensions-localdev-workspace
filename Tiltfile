# DXP
custom_build(
  'dxp', 
  "./gradlew clean buildDockerImage -Pdocker.image.id=$EXPECTED_REF", 
  deps=[
    'build.gradle',
    'configs/',
    'gradle.properties',
    'k8s/dxp',
    'settings.gradle'
  ],
  ignore=[]
)

k8s_yaml(
  local(
    "ytt -f k8s/dxp --data-value image=dxp"
  )
)

k8s_resource(
  objects=['lxc-dxp-metadata:configmap', 'dxp-ingress:ingress', 'dxp-ingress-route:ingressroute'],
  new_name='dxp-resources', labels=['dxp']
)

k8s_resource(
   workload='dxp-deployment',
   port_forwards=['8000'], 
   labels=['dxp']
)

# Extensions

# able-theme-css
#custom_build(
#  'able-theme-css',
#  "extensions/able-theme-css/tilt_build.sh",
#  deps=[
#    'extensions/able-theme-css/build.gradle',
#    'extensions/able-theme-css/client-extension.yaml',
#    'extensions/able-theme-css/package.json',
#    'extensions/able-theme-css/src'
#  ],
#  ignore=[]
#)

#k8s_yaml(local("extensions/able-theme-css/tilt_yaml.sh"))

#k8s_custom_deploy(
#  'able-theme-css-deployment',
#  apply_cmd='kapp deploy -a able-theme-css -y -f <(ytt -f k8s/extension -f extensions/able-theme-css/build/able-theme-css.client-extension-config.json --data-value image=able-theme-css --data-value serviceId=able-theme-css)', 
#  delete_cmd='kapp delete -a able-theme-css',
#  deps=['k8s/extension'],
#  image_deps=['able-theme-css']
#)

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
   workload='couponpdf',
   port_forwards=['8001'],
   labels=['extensions']
)

k8s_resource(
  objects=[
    'couponpdflocalhost-lxc-ext-provision-metadata:configmap', 
    'couponpdf-ingress:ingress',
    'couponpdf-ingress-route:ingressroute'
  ], 
  new_name='couponpdf-resources', 
  labels=['extensions']
)

#k8s_custom_deploy(
#  'couponpdf-deployment',
#  apply_cmd="kapp deploy -a couponpdf -y -f <(ytt -f k8s/extension -f extensions/couponpdf/configurator/couponpdf.client-extension-config.json --data-value cpu=500m --data-value image=couponpdf --data-value memory=512Mi --data-value serviceId=couponpdf --data-value-yaml initMetadata=true)", 
#  delete_cmd='kapp delete -a couponpdf',
#  deps=['k8s/extension']
#)
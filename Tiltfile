load('/repo/tilt/Tiltfile_functions', 'process_extension')

process_extension(
  'coupon-action-springboot', 
  'extensions/coupon-action-springboot',
  'dxp.localdev.me',
  source_deps=[
    'extensions/coupon-action-springboot/build.gradle',
    'extensions/coupon-action-springboot/client-extension.yaml',
    'extensions/coupon-action-springboot/Dockerfile'
  ])
  #'./gradlew :extensions:coupon-action-springboot:buildClientExtensionDockerImage -PimageId=$IMAGE_ID', 
  #'./gradlew :extensions:coupon-action-springboot:createClientExtensionConfig',
  #'extensions/coupon-action-springboot/build/coupon-action-springboot.client-extension-config.json',
  #'extensions/coupon-action-springboot/values.yaml', 
  #'dxp.localdev.me')
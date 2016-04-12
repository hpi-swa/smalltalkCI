accessing
compatibleConfigurationsFor: aPlatform
  ^ spec configuring select: [ :each | each isPlatformCompatible: aPlatform ]
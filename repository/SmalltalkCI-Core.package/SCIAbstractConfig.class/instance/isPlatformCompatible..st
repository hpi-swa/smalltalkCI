compatibility
isPlatformCompatible: aPlatformSymbol
  "If no platform is specified, we assume is valid for current execution platform"

  ^ self platforms isEmptyOrNil or: [ self platforms includes: aPlatformSymbol ]
compatibility
explicitTestKeys
  "keys that take precedence over tests from loaded project"

  ^ super explicitTestKeys , #(#'projects')
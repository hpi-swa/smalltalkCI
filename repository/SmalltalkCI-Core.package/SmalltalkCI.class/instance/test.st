executing
test
  ^ (self class withBuildStatusReportingDo: [ self basicTest ]) and: [ result successful ]
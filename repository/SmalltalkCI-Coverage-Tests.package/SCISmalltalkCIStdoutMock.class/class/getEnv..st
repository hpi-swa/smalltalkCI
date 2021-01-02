compatibility
getEnv: aKey

	^ aKey caseOf: {['TRAVIS'] -> ['false']} otherwise: [self error: 'Key', aKey, 'not mocked in SCISmalltalkCIStdoutMock']
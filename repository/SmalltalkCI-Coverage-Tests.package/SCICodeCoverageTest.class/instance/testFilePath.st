tests
testFilePath
	<resumable>

	| projectDir |
	projectDir := 'repository'.
	{SCICodeCoverageTestTarget>>#someInstanceMethod. 'repository/SmalltalkCI-Coverage-Tests.package/SCICodeCoverageTestTarget.class/instance/someInstanceMethod.st'.
	SCICodeCoverageTestTarget class>>#someClassMethod. 'repository/SmalltalkCI-Coverage-Tests.package/SCICodeCoverageTestTarget.class/class/someClassMethod.st'.
	Object>>#sciTestSomeExtensionMethod. 'repository/SmalltalkCI-Coverage-Tests.package/Object.extension/instance/sciTestSomeExtensionMethod.st'.
	TSCICodeCoverageTestTarget>>#someTraitInstanceMethod. 'repository/SmalltalkCI-Coverage-Tests.package/TSCICodeCoverageTestTarget.trait/instance/someTraitInstanceMethod.st'.
	TSCICodeCoverageTestTarget classTrait>>#someTraitClassMethod. 'repository/SmalltalkCI-Coverage-Tests.package/TSCICodeCoverageTestTarget.trait/class/someTraitClassMethod.st'.
	SCICodeCoverageTestTarget>>#'%&*+,|-~/<=>?@'. 'repository/SmalltalkCI-Coverage-Tests.package/SCICodeCoverageTestTarget.class/instance/^percent.and.star.plus.comma.pipe.minus.tilde.slash.less.equals.more.wat.at.st'}
		pairsDo: [:compiledMethod :expectedPath |
			| actualPath |
			actualPath := SmalltalkCI codeCoverageClass
				filePathFor: compiledMethod methodReference
				in: projectDir.
			self assert: (expectedPath copyReplaceAll: '/' with: SmalltalkCI pathNameDelimiter) equals: actualPath].
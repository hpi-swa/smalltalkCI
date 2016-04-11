executing
finishUpAfterCoverage
   | output files wrappersNotRun wrappersRun |
	wrappers do: [ :each | each uninstall ].
	wrappersRun := wrappers select: [ :each | each hasRun ].
	wrappersNotRun := wrappers reject: [ :each | each hasRun ].
	output := Dictionary new
		add: ('service_job_id' -> '1234567890');
		add: ('service_name' -> 'travis-ci').	
	
	files := Array new.
	
	wrappers do: [ :wrapper |
		self spec loading do: [ :loadspec |
			| filename method class package instanceOrClass |
			method := wrapper selector.
			(method = #'') ifTrue: [method := wrapper searchForSelector].
			class := wrapper methodClass.
			(class isKindOf: Metaclass)
				ifTrue: [
					instanceOrClass := 'class'.
					package := class soleInstance category. ]
				ifFalse: [
					instanceOrClass := 'instance'.
					package := class category. ].
			filename :=
				self projectDirectory, FileDirectory slash,
				loadspec directory, FileDirectory slash,
				package, '.package', FileDirectory slash,
				(class name), '.class', FileDirectory slash,
				instanceOrClass, FileDirectory slash,
				(method asString replaceAll: $: with: $.), '.st'.
			Transcript showln: wrapper asString, ' -> ', filename.
		]
	].
	
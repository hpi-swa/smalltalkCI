accessing-magritte
descriptionName
	<magritteDescription>
	^ MAStringDescription new
		accessor: #name;
		comment:
			'Optionally a name can be given to a new build stage, which can then be used in subsequent FROM and COPY --from=<name|index> instructions to refer to the image built in this stage. - https://docs.docker.com/engine/reference/builder/#from';
		priority: 300;
		yourself
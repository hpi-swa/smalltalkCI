accessing-magritte
descriptionCommand
	<magritteDescription>
	^ MAStringDescription new
		accessor: #command;
		priority: 100;
		required: true;
		yourself
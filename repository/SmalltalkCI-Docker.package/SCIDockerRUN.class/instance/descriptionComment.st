accessing-magritte
descriptionComment
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #comment;
		classes: { SCIDockerComment };
		priority: 200;
		yourself
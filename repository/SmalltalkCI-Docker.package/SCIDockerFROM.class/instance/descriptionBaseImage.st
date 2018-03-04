accessing-magritte
descriptionBaseImage
	<magritteDescription>
	^ MAStringDescription new
		accessor: #baseImage;
		comment:
			'The image can be any valid image – it is especially easy to start by pulling an image from the [Public Repositories](https://docs.docker.com/engine/tutorials/dockerrepos/). - https://docs.docker.com/engine/reference/builder/#from';
		priority: 100;
		required: true;
		yourself
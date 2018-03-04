accessing-magritte
descriptionTagOrDigest
	<magritteDescription>
	^ MAStringDescription new
		accessor: #tagOrDigest;
		comment: 'The tag or digest values are optional. If you omit either of them, the builder assumes a latest tag by default. The builder returns an error if it cannot find the tag value. - https://docs.docker.com/engine/reference/builder/#from';
		label: 'Tag/Digest';
		priority: 200;
		yourself
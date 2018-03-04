tests
test1
	| cmd |
	cmd := SCIDockerFROM new
		baseImage: 'ubuntu:16.04';
		yourself.
	self 
		assert: cmd
		syntax: 'FROM ubuntu:16.04'
		comment: ''
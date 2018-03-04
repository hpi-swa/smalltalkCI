tests
testEnable32BitArchitecture
	| cmd |
	cmd := SCIDockerRUN enable32BitArchitecture.
	self 
		assert: cmd
		syntax: 'RUN dpkg --add-architecture i386'
		comment: '# See https://wiki.debian.org/Multiarch/HOWTO'
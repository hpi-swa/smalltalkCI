instance creation
enable32BitArchitecture
	^ self new
			command: 'dpkg --add-architecture i386';
			comment: 'See https://wiki.debian.org/Multiarch/HOWTO';
			yourself
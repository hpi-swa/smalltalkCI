instance creation
install: packageCollection
	| cmdTemplate sortedPackages packageLines command comment |
	comment := '- Main reference: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#run	
- We chose to omit `--no-install-recommends` because the (small?) size difference didn''t seem to be worth the potential problems (see https://askubuntu.com/questions/65081/what-are-the-implications-of-no-install-recommends-apt-get-install)
- `-y` isn''t needed because it is implied in `-qq` (see https://askubuntu.com/questions/258219/how-do-i-make-apt-get-install-less-noisy#comment322444_258226).'.
	
	cmdTemplate := 'apt-get -qq update && apt-get -qq install \\
    {packages}
    && rm -rf /var/lib/apt/lists/*'.

	"Sort per https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#sort-multi-line-arguments"
	sortedPackages := packageCollection sort.
	
	packageLines := String streamContents: [ :s |
		sortedPackages 
			do: [ :e | s nextPutAll: e; nextPutAll: ' \' ]
			separatedBy: [ s lf; space; space; space; space ] ].
		
	command := cmdTemplate format: { #packages -> packageLines } asDictionary.
	^ self new
			command: command;
			comment: comment;
			yourself
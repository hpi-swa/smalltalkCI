tests
testInstall
	| cmd |
	cmd := SCIDockerRUN install: #('svn' 'git').
	self 
		assert: cmd 
		syntax: 'RUN apt-get -qq update && apt-get -qq install \
    git \
    svn \
    && rm -rf /var/lib/apt/lists/*'
		comment: '# - Main reference: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#run	
# - We chose to omit `--no-install-recommends` because the (small?) size difference didn''t seem to be worth the potential problems (see https://askubuntu.com/questions/65081/what-are-the-implications-of-no-install-recommends-apt-get-install)
# - `-y` isn''t needed because it is implied in `-qq` (see https://askubuntu.com/questions/258219/how-do-i-make-apt-get-install-less-noisy#comment322444_258226).'.
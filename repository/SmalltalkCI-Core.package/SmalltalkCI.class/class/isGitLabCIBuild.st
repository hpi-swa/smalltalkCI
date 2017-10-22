helpers
isGitLabCIBuild
	^ (self getEnv: 'GITLAB_CI') = 'true'
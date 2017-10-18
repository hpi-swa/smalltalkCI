helpers
isGitlabBuild
	^ (self getEnv: 'GITLAB_CI') = 'true'
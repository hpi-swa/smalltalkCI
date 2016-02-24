bootstrapping
installMetacello
	(Smalltalk at: #Gofer) new
		package: 'GsUpgrader-Core';
		url: 'http://ss3.gemtalksystems.com/ss/gsUpgrader';
		load.
	(Smalltalk at: #GsUpgrader) upgradeMetacello
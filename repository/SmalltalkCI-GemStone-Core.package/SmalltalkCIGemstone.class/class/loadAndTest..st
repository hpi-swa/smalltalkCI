public-api
loadAndTest: aFilenameString
  ^ self
	basicNew initialize;
	spec: (SmalltalkCISpec fromFile: aFilenameString);
	load;
	test
public-api
loadAndTest: aFilenameString
  ^ self
	basicNew initialize;
	readSTONSpec: aFilenameString;
	load;
	test
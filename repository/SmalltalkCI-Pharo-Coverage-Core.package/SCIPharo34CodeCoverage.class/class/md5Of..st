compatibility
md5Of: aFilePath

	| fr loc |

	fr := aFilePath asFileReference readStream.
	loc := ( MD5 hashMessage: fr contents ) hex.
	fr close.
	^ loc
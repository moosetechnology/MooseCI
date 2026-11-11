" Checks for VERVEINEJ_JAR path if set "
(Smalltalk os environment at: 'VERVEINEJ_JAR' ifAbsent: [ nil ]) ifNotNil: [ :path |
	FamixJavaFoldersImporter verveineJJar: path asFileReference ]

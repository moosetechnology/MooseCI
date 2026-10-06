Class {
	#name : 'MooseCIJavaProjectLoader',
	#superclass : 'MooseCIProjectLoader',
	#category : 'MooseCI-Core',
	#package : 'MooseCI-Core'
}

{ #category : 'as yet unclassified' }
MooseCIJavaProjectLoader class >> languageNameSymbol [

	^ #java
]

{ #category : 'as yet unclassified' }
MooseCIJavaProjectLoader class >> load: aProjectFilePath [

	| model |
	
	model := MCIFamixJavaFoldersImporter importFolder: aProjectFilePath asFileReference.
	model rootFolder: aProjectFilePath.
	
	^ model
]

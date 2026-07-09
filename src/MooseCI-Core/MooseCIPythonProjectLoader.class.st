Class {
	#name : 'MooseCIPythonProjectLoader',
	#superclass : 'MooseCIProjectLoader',
	#category : 'MooseCI-Core',
	#package : 'MooseCI-Core'
}

{ #category : 'as yet unclassified' }
MooseCIPythonProjectLoader class >> languageNameSymbol [

	^ #python
]

{ #category : 'as yet unclassified' }
MooseCIPythonProjectLoader class >> load: aProjectFilePath [

	^ FamixPythonImporter import: aProjectFilePath asFileReference
]

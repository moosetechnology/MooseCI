Class {
	#name : 'MooseCIPythonProjectLoader',
	#superclass : 'MooseCIProjectLoader',
	#category : 'MooseCI-Python-core',
	#package : 'MooseCI-Python',
	#tag : 'core'
}

{ #category : 'as yet unclassified' }
MooseCIPythonProjectLoader class >> languageNameSymbol [

	^ #python
]

{ #category : 'as yet unclassified' }
MooseCIPythonProjectLoader class >> load: aProjectFilePath [

	^ FamixPythonImporter import: aProjectFilePath asFileReference
]

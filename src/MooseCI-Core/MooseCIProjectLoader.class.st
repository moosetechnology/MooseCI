Class {
	#name : 'MooseCIProjectLoader',
	#superclass : 'Object',
	#category : 'MooseCI-Core',
	#package : 'MooseCI-Core'
}

{ #category : 'as yet unclassified' }
MooseCIProjectLoader class >> forLanguage: aSymbol [

	^ self allSubclasses
		  detect: [ :each | each supportsLanguage: aSymbol ]
		  ifNone: [ Error signal: 'Unsuported language: ' , aSymbol asString ]
]

{ #category : 'as yet unclassified' }
MooseCIProjectLoader class >> languageNameSymbol [

	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
MooseCIProjectLoader class >> load: aProjectFilePath [
	"Depending on the language, the creation of a model from a project can be very different.
	Put your model creation logic here, and return a mooseModel"

	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
MooseCIProjectLoader class >> supportsLanguage: aSymbol [

	^ self languageNameSymbol = aSymbol
]

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
MooseCIProjectLoader class >> load: aProjectFilePath [

	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
MooseCIProjectLoader class >> supportsLanguage: aSymbol [

	self subclassResponsibility
]

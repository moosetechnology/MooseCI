Class {
	#name : 'MooseCICLI',
	#superclass : 'Object',
	#category : 'MooseCI-CLI',
	#package : 'MooseCI-CLI'
}

{ #category : 'as yet unclassified' }
MooseCICLI class >> analyze: aFilename [
	
	Transcript show: aFilename; cr.
]

{ #category : 'as yet unclassified' }
MooseCICLI class >> printOn: aStream [
	aStream nextPutAll: 'A MooseCI CLI instance'
]

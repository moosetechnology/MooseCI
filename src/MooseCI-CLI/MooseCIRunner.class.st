Class {
	#name : 'MooseCIRunner',
	#superclass : 'Object',
	#category : 'MooseCI-CLI',
	#package : 'MooseCI-CLI'
}

{ #category : 'as yet unclassified' }
MooseCIRunner class >> analyze: aFilename [
	
	Transcript show: aFilename; cr.
]

{ #category : 'as yet unclassified' }
MooseCIRunner class >> printOn: aStream [
	aStream nextPutAll: 'A MooseCI CLI instance'
]

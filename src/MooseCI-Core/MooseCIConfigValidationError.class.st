Class {
	#name : 'MooseCIConfigValidationError',
	#superclass : 'Error',
	#instVars : [
		'messages'
	],
	#category : 'MooseCI-Core',
	#package : 'MooseCI-Core'
}

{ #category : 'signal' }
MooseCIConfigValidationError class >> signal: aCollectionOfMessages [

	^ self new
		  messages: aCollectionOfMessages;
		  signal
]

{ #category : 'accessing' }
MooseCIConfigValidationError >> messages [

	^ messages
]

{ #category : 'accessing' }
MooseCIConfigValidationError >> messages: anObject [

	messages := anObject
]

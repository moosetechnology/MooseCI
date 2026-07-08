Class {
	#name : 'MooseCILanguageDetectionResult',
	#superclass : 'Object',
	#instVars : [
		'counter'
	],
	#category : 'MooseCI-Core',
	#package : 'MooseCI-Core'
}

{ #category : 'as yet unclassified' }
MooseCILanguageDetectionResult >> at: aSymbol [ 

	^ counter at: aSymbol 
]

{ #category : 'accessing' }
MooseCILanguageDetectionResult >> counter [
	
	^ counter 
]

{ #category : 'as yet unclassified' }
MooseCILanguageDetectionResult >> files [

	^ counter values sum 
]

{ #category : 'accessing' }
MooseCILanguageDetectionResult >> incrementCountAt: aSymbol [

	counter at: aSymbol put: (counter at: aSymbol ifAbsent: [ 0 ]) + 1
]

{ #category : 'initialization' }
MooseCILanguageDetectionResult >> initialize [ 
	counter := Dictionary new.
]

{ #category : 'as yet unclassified' }
MooseCILanguageDetectionResult >> languages [ 

	^ counter keys 
]

{ #category : 'accessing' }
MooseCILanguageDetectionResult >> primary [

	| c lang |
	c := 0.
	counter keysDo: [ :key |
			(counter at: key) > c ifTrue: [
					c := counter at: key.
					lang := key ] ].
	^ lang
]

{ #category : 'accessing' }
MooseCILanguageDetectionResult >> results [

	^ counter associations asSortedCollection: [ :a :b | a value > b value ]
]

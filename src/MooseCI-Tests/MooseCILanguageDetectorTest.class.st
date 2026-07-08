Class {
	#name : 'MooseCILanguageDetectorTest',
	#superclass : 'TestCase',
	#category : 'MooseCI-Tests',
	#package : 'MooseCI-Tests'
}

{ #category : 'as yet unclassified' }
MooseCILanguageDetectorTest >> testDetectOneLang [ 
	|detectResult|
	detectResult := MooseCILanguageDetector detect: MooseCIBridge mockProjectTests / 'oneLang'. 
	
	self assert: detectResult languages size equals: 1.
	self assert: (detectResult languages includes: #python).
	self assert: (detectResult at: #python ) equals: 5.
	self assert: detectResult primary  equals: #python.
	
]

{ #category : 'as yet unclassified' }
MooseCILanguageDetectorTest >> testIgnoredDirectories [
	|detectResult|
	detectResult := MooseCILanguageDetector detect: MooseCIBridge mockProjectTests / 'oneLang'. 
	
	self assert: detectResult files equals: 5.
	self assert: detectResult primary equals: #python.
	
]

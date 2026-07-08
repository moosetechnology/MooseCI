Class {
	#name : 'MooseCILanguageDetectorTest',
	#superclass : 'TestCase',
	#category : 'MooseCI-Tests',
	#package : 'MooseCI-Tests'
}

{ #category : 'as yet unclassified' }
MooseCILanguageDetectorTest >> testDetectOneLang [ 
	|detectResult|
	detectResult := MooseCILanguageDetector detect: MooseCIBridge mockProjectTests / 'one-lang'. 
	
	self assert: detectResult languages size equals: 1.
	self assert: (detectResult languages includes: #python).
	self assert: (detectResult at: #python ) equals: 5.
	self assert: detectResult primary  equals: #python.
	
]

{ #category : 'as yet unclassified' }
MooseCILanguageDetectorTest >> testIgnoredDirectories [
	|detectResult|
	detectResult := MooseCILanguageDetector detect: MooseCIBridge mockProjectTests / 'one-lang'. 
	
	self assert: detectResult files equals: 5.
	self assert: detectResult primary equals: #python.
	
]

{ #category : 'as yet unclassified' }
MooseCILanguageDetectorTest >> testMixedRepoRankedByCount [

	| detectResult |
	detectResult := MooseCILanguageDetector detect: MooseCIBridge mockProjectTests / 'mixed-java-python'.

	self assert: detectResult results first key equals: #java. "more .java files in the folder"
	self assert: detectResult results size equals: 2
]

{ #category : 'as yet unclassified' }
MooseCILanguageDetectorTest >> testNoLangDetected [

	| detectResult |
	detectResult := MooseCILanguageDetector detect: MooseCIBridge mockProjectTests / 'no-lang'.

	self assert: detectResult results isEmpty 
]

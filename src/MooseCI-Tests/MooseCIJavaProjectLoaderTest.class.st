"
MooseCIJavaProjectLoaderTest is a test class for testing the behavior of MooseCIJavaProjectLoader.
"
Class {
	#name : 'MooseCIJavaProjectLoaderTest',
	#superclass : 'TestCase',
	#category : 'MooseCI-Tests',
	#package : 'MooseCI-Tests'
}

{ #category : 'tests' }
MooseCIJavaProjectLoaderTest >> testJavaLoaderIsSelectedForJava [

	self
		assert: (MooseCIProjectLoader forLanguage: #java)
		equals: MooseCIJavaProjectLoader
]

{ #category : 'tests' }
MooseCIJavaProjectLoaderTest >> testLanguageNameSymbol [

	self assert: MooseCIJavaProjectLoader languageNameSymbol equals: #java
]

{ #category : 'tests' }
MooseCIJavaProjectLoaderTest >> testLoadJavaProjectReturnsFamixJavaModel [

	| model projectPath |
	projectPath := MooseCIBridge mockProjectTests / 'java-only'.
	model := MooseCIJavaProjectLoader load: projectPath.

	self assert: (model isKindOf: FamixJavaModel).
	self assert: model isNotEmpty.
	self assert: (model allClasses anySatisfy: [ :c | c name = 'Main' ]).
	self assert: (model allClasses anySatisfy: [ :c | c name = 'DummyClass' ]).
	self assert: (model allClasses anySatisfy: [ :c | c name = 'NoDocstring' ]).
	self
		assert: model rootFolder asFileReference fullName
		equals: projectPath fullName
]

Class {
	#name : 'MooseCICLITest',
	#superclass : 'TestCase',
	#category : 'MooseCI-Tests',
	#package : 'MooseCI-Tests'
}

{ #category : 'tests' }
MooseCICLITest >> testAnalyzeGitProjectCommand [

	| context gitUrl |
	gitUrl := 'https://github.com/deel-ai/puncc'.
	context := MooseCICLI mooseci activateWith: {
			           'mooseci'.
			           'analyze'.
			           '--url'.
			           gitUrl }.

	self assert: (context stdio stdout contents utf8Decoded includesSubstring: 'Analyzing ' , gitUrl).
	self assert: context exitStatus equals: 0
]

{ #category : 'tests' }
MooseCICLITest >> testAnalyzeLocalProjectCommand [

	| context projectPath |
	projectPath := (MooseCIBridge mockProjectTests / 'one-lang') fullName.
	context := MooseCICLI mooseci activateWith: {
			           'mooseci'.
			           'analyze'.
			           projectPath }.

	self assert: (context stdio stdout contents utf8Decoded includesSubstring: 'Analyzing ' , projectPath).
	self assert: context exitStatus equals: 0
]

{ #category : 'tests' }
MooseCICLITest >> testAnalyzeLocalProjectCommandNoProjectPathProvided [

	| context |
	
	self assertBlock: [ context := MooseCICLI mooseci activateWith: { 'mooseci'. 'analyze' } ] raises: NotFound.
	
]

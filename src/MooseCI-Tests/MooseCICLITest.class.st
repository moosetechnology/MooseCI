Class {
	#name : 'MooseCICLITest',
	#superclass : 'TestCase',
	#category : 'MooseCI-Tests',
	#package : 'MooseCI-Tests'
}

{ #category : 'tests' }
MooseCICLITest >> testAnalyzeCommandWithConfig [

	| context |
	context := MooseCICLI mooseci activateWith: {
			           'moose-ci'.
			           'analyze'}.

	self assert: (context stdio stdout contents utf8Decoded includesSubstring: 'moose-ci.ston found').
	self assert: context exitStatus equals: 0
]

{ #category : 'tests' }
MooseCICLITest >> testAnalyzeCommandWithConfigInvalid [

	| context |
	context := MooseCICLI mooseci activateWith: {
			           'moose-ci'.
			           'analyze'}.

	self assert: (context stdio stdout contents utf8Decoded includesSubstring: 'Invalid configuration file').
	self assert: context exitStatus equals: 1
]

{ #category : 'tests' }
MooseCICLITest >> testAnalyzeCommandWithConfigNotFound [

	self assertBlock: [ MooseCICLI mooseci activateWith: { 'moose-ci'. 'analyze' } ] raises: FileDoesNotExistException
]

{ #category : 'tests' }
MooseCICLITest >> testAnalyzeCommandWithConfigValid [

	| context |
	context := MooseCICLI mooseci activateWith: {
			           'moose-ci'.
			           'analyze'}.

	self assert: (context stdio stdout contents utf8Decoded includesSubstring: 'Valid configuration file').
	self assert: context exitStatus equals: 0
]

{ #category : 'tests' }
MooseCICLITest >> testAnalyzeGitProjectCommand [

	| context gitUrl |
	gitUrl := 'https://github.com/deel-ai/puncc'.
	context := MooseCICLI mooseci activateWith: {
			           'moose-ci'.
			           'analyze'.
			           '--url'.
			           gitUrl }.

	self assert: (context stdio stdout contents utf8Decoded includesSubstring: 'Analyzing remote project: ' , gitUrl).
	self assert: context exitStatus equals: 0
]

{ #category : 'tests' }
MooseCICLITest >> testAnalyzeLocalProjectCommand [

	| context projectPath |
	projectPath := (MooseCIBridge mockProjectTests / 'one-lang') fullName.
	context := MooseCICLI mooseci activateWith: {
			           'moose-ci'.
			           'analyze'.
			           projectPath }.

	self assert: (context stdio stdout contents utf8Decoded includesSubstring: 'Analyzing ' , projectPath).
	self assert: context exitStatus equals: 0
]

{ #category : 'tests' }
MooseCICLITest >> testAnalyzeLocalProjectCommandNoProjectPathProvided [

	| context |
	
	self assertBlock: [ context := MooseCICLI mooseci activateWith: { 'moose-ci'. 'analyze' } ] raises: NotFound.
	
]

{ #category : 'tests' }
MooseCICLITest >> testInitCommand [

	| context |
	context := MooseCICLI mooseci activateWith: {
			           'moose-ci'.
			           'init'}.

	self assert: (context stdio stdout contents utf8Decoded includesSubstring: 'Creating a MooseCI config file...').
	self assert: context exitStatus equals: 0
]

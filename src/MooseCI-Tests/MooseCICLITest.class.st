Class {
	#name : 'MooseCICLITest',
	#superclass : 'TestCase',
	#instVars : [
		'workingDirectory',
		'previousWorkingDirectory'
	],
	#category : 'MooseCI-Tests',
	#package : 'MooseCI-Tests'
}

{ #category : 'running' }
MooseCICLITest >> setUp [

	super setUp.
	"Run each test in a fresh working directory holding a tiny project, so the CLI neither reads nor overwrites the moose-ci.ston next to the image"
	workingDirectory := (FileLocator temp / ('moose-ci-cli-test-' , UUID new asString36)) asFileReference.
	workingDirectory ensureCreateDirectory.
	MooseCIBridge mockProjectTests / 'one-file' / 'main.py' copyTo: workingDirectory / 'main.py'.
	previousWorkingDirectory := DiskStore classVarNamed: #DefaultWorkingDirectory.
	DiskStore classVarNamed: #DefaultWorkingDirectory put: workingDirectory path
]

{ #category : 'running' }
MooseCICLITest >> tearDown [

	DiskStore classVarNamed: #DefaultWorkingDirectory put: previousWorkingDirectory.
	workingDirectory ensureDeleteAll.
	super tearDown
]

{ #category : 'tests' }
MooseCICLITest >> testAnalyzeCommandWithConfig [

	| context |
	self writeConfig: MooseCIConfig python.
	context := MooseCICLI mooseci activateWith: { 'moose-ci'. 'analyze' }.

	self assert: (context stdio stdout contents utf8Decoded includesSubstring: 'moose-ci.ston found').
	self assert: context exitStatus equals: 0
]

{ #category : 'tests' }
MooseCICLITest >> testAnalyzeCommandWithConfigInvalid [

	| context |
	self writeConfig: (MooseCIConfig python
			 rules: #(  );
			 yourself).
	context := MooseCICLI mooseci activateWith: { 'moose-ci'. 'analyze' }.

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
	self writeConfig: MooseCIConfig python.
	context := MooseCICLI mooseci activateWith: { 'moose-ci'. 'analyze' }.

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
	self writeConfig: MooseCIConfig python.
	context := MooseCICLI mooseci activateWith: { 'moose-ci'. 'analyze' }.

	self assert: (context stdio stdout contents utf8Decoded includesSubstring: 'Analyzing ' , workingDirectory fullName).
	self assert: context exitStatus equals: 0
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

{ #category : 'tests' }
MooseCICLITest >> testInitCommandDetectsLanguage [

	| context |
	context := MooseCICLI mooseci activateWith: {
			           'moose-ci'.
			           'init'}.

	self assert: (context stdio stdout contents utf8Decoded includesSubstring: 'Language detected:').
	self assert: context exitStatus equals: 0
]

{ #category : 'running' }
MooseCICLITest >> writeConfig: aMooseCIConfig [

	workingDirectory / MooseCIConfig configFileName writeStreamDo: [ :stream | stream nextPutAll: aMooseCIConfig toSton ]
]

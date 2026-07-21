Class {
	#name : 'MooseCIAnalyzeCommand',
	#superclass : 'ClapApplication',
	#instVars : [
		'config'
	],
	#category : 'MooseCI-CLI',
	#package : 'MooseCI-CLI'
}

{ #category : 'private' }
MooseCIAnalyzeCommand class >> analyze [
	
	<commandline>
	^ (ClapCommandSpec id: #analyze)
		description: 'Analyze a project';
		commandClass: self;
		addPositional: #projectPath description: 'Path to the project to analyze';
		addFlagWithPositional: #url  description: 'A public git repository url' ;
		addHelp;
        yourself
]

{ #category : 'executing' }
MooseCIAnalyzeCommand >> execute [

	'Hello' traceCr.
	config := MooseCIConfig default.

	self isGitRepository
		ifTrue: [
				self outputStreamDo: [ :out |
						out nextPutAll: 'Analyzing remote project: ' , self url.
						out lf ].
				config isRemote.
				config gitProjectUrl: self url.
				self flag: #todo "refactor to just runAnalysisFromConfig: config
				
				so we can just call the MooseCIRunner once".
				MooseCIRunner analyzeFromGitUrl: self url config: config ]
		ifFalse: [
				self outputStreamDo: [ :out |
						out nextPutAll: 'Analyzing ' , self projectPath.
						out lf ].
				config projectPath: self projectPath.
				MooseCIRunner analyze: self projectPath config: config ].

	self exitSuccess
]

{ #category : 'executing' }
MooseCIAnalyzeCommand >> isGitRepository [

	^ self hasFlag: #url
]

{ #category : 'executing' }
MooseCIAnalyzeCommand >> projectPath [

	^ self positional: #projectPath
]

{ #category : 'executing' }
MooseCIAnalyzeCommand >> url [

	^ self positional: #url
]

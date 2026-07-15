Class {
	#name : 'MooseCIAnalyzeCommand',
	#superclass : 'ClapApplication',
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

	self isGitRepository
		ifTrue: [
				self outputStreamDo: [ :out |
						out nextPutAll: 'Analyzing remote project: ' , self url.
						out lf ].
				MooseCIRunner analyzeFromGitUrl: self url ]
		ifFalse: [
				self outputStreamDo: [ :out |
						out nextPutAll: 'Analyzing ' , self projectPath.
						out lf ].
				MooseCIRunner analyze: self projectPath ].

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

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
		  addPositional: #projectPath spec: [ :positional |
				  positional
					  description: 'Path to the project to analyze';
					  defaultValue: [ :arg :app | nil ] ];
		  addFlagWithPositional: #url description: 'A public git repository url';
		  addHelp;
		  yourself
]

{ #category : 'executing' }
MooseCIAnalyzeCommand >> buildConfigFromFlags [

	| config |
	config := MooseCIConfig default.

	self isGitRepository
		ifTrue: [
				config isRemote: true.
				config gitProjectUrl: self url ]
		ifFalse: [ config projectPath: self projectPath ].

	^ config
]

{ #category : 'executing' }
MooseCIAnalyzeCommand >> execute [

	| projectPathGiven configFile config |
	configFile := FileLocator workingDirectory / MooseCIConfig configFileName.

	projectPathGiven := self isLocalProject or: self isGitRepository.

	(configFile exists not and: [ projectPathGiven not ]) ifTrue: [
			FileDoesNotExistException signal: 'Config file not found, try running `moose-ci init` to create one'. ].

	config := (configFile exists and: [ projectPathGiven not ])
		          ifTrue: [ self loadConfigFrom: configFile ]
		          ifFalse: [ self buildConfigFromFlags ].

	config validate.

	self runAnalysisWith: config.

	self exitSuccess
]

{ #category : 'executing' }
MooseCIAnalyzeCommand >> hasNoArgumentsOrOptions [

|flags options|

flags := #()
]

{ #category : 'executing' }
MooseCIAnalyzeCommand >> isGitRepository [

	^ self hasFlag: #url
]

{ #category : 'executing' }
MooseCIAnalyzeCommand >> isLocalProject [

	^ self projectPath isNotNil
]

{ #category : 'executing' }
MooseCIAnalyzeCommand >> loadConfigFrom: aFileReference [

	^ aFileReference readStreamDo: [ :stream | STON fromStream: stream ]
]

{ #category : 'executing' }
MooseCIAnalyzeCommand >> projectPath [

	^ self positional: #projectPath
]

{ #category : 'as yet unclassified' }
MooseCIAnalyzeCommand >> runAnalysisWith: aMooseCIConfig [

	aMooseCIConfig isRemote
		ifTrue: [
				self outputStreamDo: [ :out |
						out
							nextPutAll: 'Analyzing remote project: ';
							nextPutAll: aMooseCIConfig gitProjectUrl;
							lf ].
				MooseCIRunner analyzeFromGitUrlWith: aMooseCIConfig ]
		ifFalse: [
				self outputStreamDo: [ :out |
						out
							nextPutAll: 'Analyzing ';
							nextPutAll: aMooseCIConfig projectPath;
							lf ].
				MooseCIRunner analyze: aMooseCIConfig projectPath config: aMooseCIConfig ]
]

{ #category : 'executing' }
MooseCIAnalyzeCommand >> url [

	^ self positional: #url
]

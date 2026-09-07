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
				config gitProjectUrl: self url ].

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
		          ifTrue: [
				          self outputStreamDo: [ :out |
						          out
							          nextPutAll: 'moose-ci.ston found';
							          lf ].
				          self loadConfigFrom: configFile ]
		          ifFalse: [ self buildConfigFromFlags ].

	(self validateConfig: config) ifFalse: [ ^ self ].

	self outputStreamDo: [ :out |
		out
			nextPutAll: 'Valid configuration file';
			lf ].

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

{ #category : 'executing' }
MooseCIAnalyzeCommand >> projectPathForAnalysis [

	^ self projectPath ifNil: [ FileLocator workingDirectory fullName ]
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
				| projectPath |
				projectPath := self projectPathForAnalysis.
				self outputStreamDo: [ :out |
						out
							nextPutAll: 'Analyzing ';
							nextPutAll: projectPath;
							lf ].
				MooseCIRunner analyze: projectPath config: aMooseCIConfig ]
]

{ #category : 'executing' }
MooseCIAnalyzeCommand >> url [

	^ self positional: #url
]

{ #category : 'executing' }
MooseCIAnalyzeCommand >> validateConfig: aMooseCIConfig [

	[
		aMooseCIConfig validate.
		^ true ]
		on: MooseCIConfigValidationError
		do: [ :error |
				self outputStreamDo: [ :out |
						out
							nextPutAll: (AnsiColor red: 'Invalid configuration file');
							lf.
						error messages do: [ :message |
								out
									tab;
									nextPutAll: message;
									lf ] ].
				Exit signalFailure.
				^ false ]
]

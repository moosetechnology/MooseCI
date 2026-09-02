Class {
	#name : 'MooseCIInitCommand',
	#superclass : 'ClapApplication',
	#category : 'MooseCI-CLI',
	#package : 'MooseCI-CLI'
}

{ #category : 'private - initialization' }
MooseCIInitCommand class >> init [
	
	<commandline>
	^ (ClapCommandSpec id: #init)
		description: 'Initializing a configuration file for moose-ci';
		commandClass: self;
		addHelp;
        yourself
]

{ #category : 'as yet unclassified' }
MooseCIInitCommand >> createConfigFileFor: aSymbol [

	| config |
	
	config := MooseCIConfig for: aSymbol.
	config projectPath: FileLocator workingDirectory fullName.
	
	FileLocator workingDirectory / MooseCIConfig configFileName writeStreamDo: [ :stream | stream nextPutAll: config toSton ]
]

{ #category : 'as yet unclassified' }
MooseCIInitCommand >> createDefaultStonConfigFile [

	| config |
	
	config := MooseCIConfig default.
	config projectPath: FileLocator workingDirectory fullName.
	
	FileLocator workingDirectory / MooseCIConfig configFileName writeStreamDo: [ :stream | stream nextPutAll: config toSton ]
]

{ #category : 'execution' }
MooseCIInitCommand >> execute [

	| fileName language |
	fileName := MooseCIConfig configFileName.
	self outputStreamDo: [ :out |
			out
				lf;
				nextPutAll: 'Creating a MooseCI config file...';
				lf;
				lf ].
	language := MooseCILanguageDetector detect: FileLocator workingDirectory.

	self outputStreamDo: [ :out |
			out
				lf;
				nextPutAll: 'Language detected: ';
				nextPutAll: language primary asString;
				lf;
				lf ].

	[
		self createConfigFileFor: language primary.
		
		self outputStreamDo: [ :out |
				out
					nextPutAll: (AnsiColor green: 'Config written to ' , fileName);
					lf;
					lf;
					nextPutAll: 'Run `moose-ci analyze` to use it.';
					lf ].
		self exitSuccess ]
		on: Error
		do: [ :e |
				self outputStreamDo: [ :out |
						out
							nextPutAll: (AnsiColor red: 'Error while creating the config file');
							nextPutAll: e messageText.
						out lf ] ]
]

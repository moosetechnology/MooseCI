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
MooseCIInitCommand >> createDefaultStonConfigFile [

	| config |
	
	config := MooseCIConfig default.
	config projectPath: FileLocator workingDirectory fullName.
	
	FileLocator workingDirectory / MooseCIConfig configFileName writeStreamDo: [ :stream | stream nextPutAll: config toSton ]
]

{ #category : 'execution' }
MooseCIInitCommand >> execute [
|fileName|
fileName := MooseCIConfig configFileName.
	self outputStreamDo: [ :out |
			out
				lf;
				nextPutAll: 'Creating a MooseCI config file...';
				lf;
				lf ].
	[
		self createDefaultStonConfigFile.
		self outputStreamDo: [ :out |
				out
					nextPutAll: (AnsiColor green: 'Config written to ', fileName );
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

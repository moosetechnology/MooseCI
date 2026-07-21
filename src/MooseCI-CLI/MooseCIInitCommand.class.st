Class {
	#name : 'MooseCIInitCommand',
	#superclass : 'ClapApplication',
	#instVars : [
		'config'
	],
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

	FileLocator workingDirectory / 'moose-ci.ston' writeStreamDo: [ :stream | stream nextPutAll: MooseCIConfig default toSton ]
]

{ #category : 'execution' }
MooseCIInitCommand >> execute [

	self outputStreamDo: [ :out |
			out
				lf;
				nextPutAll: 'Creating a moose-ci.ston file...';
				lf;
				lf ].
	[
		self createDefaultStonConfigFile.
		self outputStreamDo: [ :out |
				out
					nextPutAll: (AnsiColor green: 'Config written to moose-ci.ston');
					lf;
					lf;
					nextPutAll: 'Run `moose-ci analyze` to use it.';
					lf ].
		self exitSuccess ]
		on: Error
		do: [ :e |
				self outputStreamDo: [ :out |
						out
							nextPutAll: (AnsiColor red: 'Error while creating the moose-ci.ston');
							nextPutAll: e messageText.
						out lf ] ]
]

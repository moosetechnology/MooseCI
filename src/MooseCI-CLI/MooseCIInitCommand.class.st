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

{ #category : 'execution' }
MooseCIInitCommand >> execute [ 

	self outputStreamDo: [ :out |
						out nextPutAll: 'Creating a moose-ci.ston file...'.
						out lf ].
					
	self exitSuccess 
]

Class {
	#name : 'MooseCICLI',
	#superclass : 'ClapApplication',
	#category : 'MooseCI-CLI',
	#package : 'MooseCI-CLI'
}

{ #category : 'as yet unclassified' }
MooseCICLI class >> mooseci [

	<commandline>
	^ (ClapCommandSpec id: #'moose-ci')
		  description: (AnsiColor yellow: 'Moose-CI - automated software analysis reports');
		  commandClass: self;
		  add: MooseCIAnalyzeCommand analyze;
		  add: MooseCIInitCommand init;
		  addHelp;
		  yourself
]

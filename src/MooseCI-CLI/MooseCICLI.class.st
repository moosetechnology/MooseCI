Class {
	#name : 'MooseCICLI',
	#superclass : 'ClapApplication',
	#category : 'MooseCI-CLI',
	#package : 'MooseCI-CLI'
}

{ #category : 'as yet unclassified' }
MooseCICLI class >> mooseci [

	<commandline>
	^ (ClapCommandSpec id: #mooseci)
		  description: (AnsiColor yellow: 'Moose-CI - automated software analysis reports');
		  commandClass: self;
		  add: MooseCIAnalyzeCommand analyze;
		  addHelp;
		  yourself
]

Class {
	#name : 'MooseCIRunner',
	#superclass : 'Object',
	#instVars : [
		'projectFilePath',
		'mooseCICore'
	],
	#classInstVars : [
		'mooseCI'
	],
	#category : 'MooseCI-CLI',
	#package : 'MooseCI-CLI'
}

{ #category : 'as yet unclassified' }
MooseCIRunner class >> analyze: aProjectPath config: aMooseCIConfig [
	
	(self new projectFilePath: aProjectPath ) runWithConfig: aMooseCIConfig .
]

{ #category : 'as yet unclassified' }
MooseCIRunner class >> analyzeFromGitUrlWith: aMooseCIConfig [
	
	
]

{ #category : 'as yet unclassified' }
MooseCIRunner class >> printOn: aStream [
	aStream nextPutAll: 'A MooseCI CLI instance'
]

{ #category : 'running' }
MooseCIRunner >> loadProject [

	'Importing ', mooseCICore config projectPath, '...' traceCr.
	mooseCICore loadProject.
	'Famix model created.' traceCr.
]

{ #category : 'accessing' }
MooseCIRunner >> projectFilePath: anObject [

	projectFilePath := anObject
]

{ #category : 'running' }
MooseCIRunner >> runAnalysis [
	mooseCICore runAnalysis.
]

{ #category : 'running' }
MooseCIRunner >> runWithConfig: aMooseCIConfig [

	mooseCICore := MooseCICore new
		               config: aMooseCIConfig;
		               yourself.
	self loadProject.
	self runAnalysis.
	self writeOutput
]

{ #category : 'running' }
MooseCIRunner >> writeCriticsOutput [

	| violations passed|
	violations := mooseCICore violations.
	passed := (violations select: [ :each | each isEmpty ]) size.

	(AnsiColor yellow: 'Quality (',passed asString, '/', violations size asString, ' passed)') traceCr.

	violations keysDo: [ :condition |
			| violationOutput |
			violationOutput := '    ', (violations at: condition) size asString , ' ', condition name.
			violationOutput := (violations at: condition) size = 0
				                   ifTrue: [ (AnsiColor green: violationOutput) ]
				                   ifFalse: [ (AnsiColor red: violationOutput) ].

			violationOutput traceCr ]
]

{ #category : 'running' }
MooseCIRunner >> writeMetricsOutput [
	
	| metrics |
	
	metrics := mooseCICore metricsReport. 
	(AnsiColor yellow: 'Metrics') traceCr.
	('    ', metrics files asString , ' files | ', metrics loc asString, ' LOC | ', metrics packages asString, ' packages | ', metrics classes asString, ' classes') traceCr
]

{ #category : 'running' }
MooseCIRunner >> writeOutput [
	
	self writeMetricsOutput.
	self writeCriticsOutput.
]

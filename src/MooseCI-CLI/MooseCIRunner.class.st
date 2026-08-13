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
MooseCIRunner >> writeOutput [

	| reporter |
	reporter := mooseCICore analysisReport.
	reporter writeConsole.
	reporter writeFiles
]

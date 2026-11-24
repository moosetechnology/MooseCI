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

	'Importing ', projectFilePath, '...' traceCr.
	mooseCICore loadProject.
	'Famix model created.' traceCr.
]

{ #category : 'accessing' }
MooseCIRunner >> mooseCICore: aMooseCICore [

	mooseCICore := aMooseCICore
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
		               projectPath: projectFilePath;
		               yourself.
	self loadProject.
	self runAnalysis.
	self writeOutput
]

{ #category : 'writing' }
MooseCIRunner >> writeFileList: someFiles on: aStream [
	"Paths relative to the analyzed project folder (the working directory), e.g. .moose-ci/report/report.json"

	| projectFolder |
	projectFolder := FileLocator workingDirectory asFileReference.
	aStream
		nextPutAll: (AnsiColor yellow: 'Files');
		lf.
	someFiles do: [ :each |
			aStream
				nextPutAll: '    ' , (each relativeTo: projectFolder) pathString;
				lf ]
]

{ #category : 'writing' }
MooseCIRunner >> writeOutput [

	self writeOutputOn: Stdio stdout
]

{ #category : 'writing' }
MooseCIRunner >> writeOutputOn: aStream [

	| reporter files |
	reporter := mooseCICore analysisReport.
	MCIConsoleReportWriter new
		report: reporter;
		writeOn: aStream.

	self writeStep: 'Generating report...' on: aStream.
	files := reporter writeFiles asOrderedCollection.

	(mooseCICore config visualizations ifNil: [ #(  ) ]) ifNotEmpty: [
			self writeStep: 'Generating visualizations...' on: aStream.
			files addAll: (mooseCICore writeVisualizationsIn: reporter outputDirectory / 'visualizations') ].

	self writeFileList: files on: aStream
]

{ #category : 'writing' }
MooseCIRunner >> writeStep: aString on: aStream [

	aStream
		nextPutAll: aString;
		lf
]

Class {
	#name : 'MCIReportTestCase',
	#superclass : 'TestCase',
	#instVars : [
		'metrics',
		'condition',
		'entities',
		'violations',
		'report',
		'mooseCICore'
	],
	#category : 'MooseCI-Tests',
	#package : 'MooseCI-Tests'
}

{ #category : 'helpers' }
MCIReportTestCase >> entityNamed: aName [

	^ FamixPythonModule new
		  name: aName;
		  yourself
]

{ #category : 'running' }
MCIReportTestCase >> setUp [

	super setUp.
	mooseCICore := MooseCICore new.
	mooseCICore config: (MooseCIConfig default
			 outputPath: 'moose-ci-test-report';
			 projectPath: MooseCIBridge mockProjectTests / 'one-lang';
			 yourself).
			
	mooseCICore loadProject.
	mooseCICore runAnalysis.
	
	report := mooseCICore analysisReport.
	
	metrics := report metrics.

	violations := report violations.
	
	
]

{ #category : 'running' }
MCIReportTestCase >> tearDown [
	(FileLocator workingDirectory / 'moose-ci-test-report') exists
		ifTrue: [ (FileLocator workingDirectory / 'moose-ci-test-report') ensureDeleteAll ].
	(FileLocator workingDirectory / 'moose-ci-test-report.json') exists
		ifTrue: [ (FileLocator workingDirectory / 'moose-ci-test-report.json') ensureDelete ].
	super tearDown
]

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

{ #category : 'running' }
MCIReportTestCase >> setUp [

	super setUp.
	mooseCICore := MooseCICore new.
	mooseCICore config: (MooseCIConfig java
			 outputPath: 'moose-ci-test-report';
			 yourself).
	mooseCICore projectPath: MooseCIBridge mockProjectTests / 'java-only'.
			
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
	super tearDown
]

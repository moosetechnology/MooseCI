Class {
	#name : 'MCIReportTestCase',
	#superclass : 'TestCase',
	#instVars : [
		'config',
		'metrics',
		'condition',
		'entities',
		'violations',
		'report'
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
	config := MooseCIConfig default
		outputPath: 'moose-ci-test-report';
		yourself.
	metrics := MooseCIMetricsReport new
		files: 3;
		loc: 42;
		packages: 2;
		classes: 1;
		yourself.
	condition := FamixCBCondition new
		name: 'File with too many LOC';
		severity: FamixCBWarningSeverity;
		yourself.
	entities := { self entityNamed: 'main.py'. self entityNamed: 'utils.py' }.
	violations := { condition -> entities } asDictionary.
	report := MCIAnalysisReport newFrom: config metrics: metrics violations: violations
]

{ #category : 'running' }
MCIReportTestCase >> tearDown [
	(FileLocator workingDirectory / 'moose-ci-test-report') exists
		ifTrue: [ (FileLocator workingDirectory / 'moose-ci-test-report') ensureDeleteAll ].
	(FileLocator workingDirectory / 'moose-ci-test-report.json') exists
		ifTrue: [ (FileLocator workingDirectory / 'moose-ci-test-report.json') ensureDelete ].
	super tearDown
]

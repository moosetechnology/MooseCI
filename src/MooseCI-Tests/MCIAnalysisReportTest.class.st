Class {
	#name : 'MCIAnalysisReportTest',
	#superclass : 'MCIReportTestCase',
	#category : 'MooseCI-Tests',
	#package : 'MooseCI-Tests'
}

{ #category : 'tests' }
MCIAnalysisReportTest >> testNewFrom [

	| newReport |
	newReport := MCIAnalysisReport newFrom: mooseCICore config metrics: metrics violations: violations.

	self assert: newReport config equals: mooseCICore config.
	self assert: newReport metrics equals: metrics.
	self assert: newReport violations equals: violations
]

{ #category : 'tests' }
MCIAnalysisReportTest >> testOutputDirectory [

	self assert: report outputDirectory equals: (FileLocator workingDirectory / 'moose-ci-test-report')
]

{ #category : 'tests' }
MCIAnalysisReportTest >> testWriteFiles [

	| outputDirectory |
	report writeFiles.

	outputDirectory := FileLocator workingDirectory / 'moose-ci-test-report'.

	self assert: outputDirectory hasFiles.
	self assert: outputDirectory files first extension equals: 'json'.
	self assert: (outputDirectory files first contents includesSubstring: 'DummyClass')
]

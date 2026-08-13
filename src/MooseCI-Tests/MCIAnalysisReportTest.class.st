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

	| outputFile |
	
	report writeFiles.
	
	outputFile := FileLocator workingDirectory / 'moose-ci-test-report' / 'report.json'.

	self assert: outputFile exists.
	self assert: (outputFile contents includesSubstring: 'DummyClass')
]

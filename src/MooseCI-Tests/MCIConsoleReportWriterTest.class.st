Class {
	#name : 'MCIConsoleReportWriterTest',
	#superclass : 'MCIReportTestCase',
	#category : 'MooseCI-Tests',
	#package : 'MooseCI-Tests'
}

{ #category : 'tests' }
MCIConsoleReportWriterTest >> testWriteCriticsOnStream [

	| contents |
	contents := String streamContents: [ :stream |
		MCIConsoleReportWriter new report: report; writeOn: stream ].

	self assert: (contents includesSubstring: 'Quality').
	self assert: (contents includesSubstring: 'Metrics')
]

{ #category : 'tests' }
MCIConsoleReportWriterTest >> testWriteMetricsOnStream [

	| contents |
	contents := String streamContents: [ :stream |
		MCIConsoleReportWriter new report: report; writeOn: stream ].

	self assert: (contents includesSubstring: 'Metrics').
	self assert: (contents includesSubstring: 'Classes')
]

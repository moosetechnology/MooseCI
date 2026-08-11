Class {
	#name : 'MCIConsoleReportWriterTest',
	#superclass : 'MCIReportTestCase',
	#category : 'MooseCI-Tests',
	#package : 'MooseCI-Tests'
}

{ #category : 'tests' }
MCIConsoleReportWriterTest >> testWriteMetricsOnStream [

	| contents |
	contents := String streamContents: [ :stream |
		MCIConsoleReportWriter new report: self report; writeOn: stream ].

	self assert: (contents includesSubstring: 'Metrics').
	self assert: (contents includesSubstring: '3 files | 42 LOC | 2 packages | 1 classes')
]

{ #category : 'tests' }
MCIConsoleReportWriterTest >> testWriteCriticsOnStream [

	| contents |
	contents := String streamContents: [ :stream |
		MCIConsoleReportWriter new report: self report; writeOn: stream ].

	self assert: (contents includesSubstring: 'Quality (0/1 passed)').
	self assert: (contents includesSubstring: '2 File with too many LOC')
]

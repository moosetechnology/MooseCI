Class {
	#name : 'MCIJSONReportWriterTest',
	#superclass : 'MCIReportTestCase',
	#category : 'MooseCI-Tests',
	#package : 'MooseCI-Tests'
}

{ #category : 'tests' }
MCIJSONReportWriterTest >> testJsonStringContainsMetricsAndViolations [

	| contents |
	contents := (MCIReportWriter writerAt: #json) new report: report; jsonString.

	self assert: (contents includesSubstring: 'metrics').
	self assert: (contents includesSubstring: 'violations').
	self assert: (contents includesSubstring: 'No docstring').
	self assert: (contents includesSubstring: 'DummyClass').
	self assert: (contents includesSubstring: 'Hint')
]

{ #category : 'tests' }
MCIJSONReportWriterTest >> testJsonStringIsValidJson [

	| json metrics violations |
	json := STONJSON fromString: (MCIJSONReportWriter new report: report; jsonString).

	metrics := json at: 'metrics'.
	self assert: (metrics at: 'files') equals: 8.
	self assert: (metrics at: 'loc') equals: 5.
	self assert: (metrics at: 'packages') equals: 2.
	self assert: (metrics at: 'classes') equals: 3.

	violations := (json at: 'violations') collect: [ :group | group asDictionary ].
	self assert: (violations first at: 'rule') equals: 'No docstring'.
	self assert: (violations first at: 'severity') equals: 'Warning'.
	self assert: (violations first at: 'count') equals: 1.
	self assert: ((violations first at: 'entities') includes: 'main.py')
]

Class {
	#name : 'MCIJSONReportWriterTest',
	#superclass : 'MCIReportTestCase',
	#category : 'MooseCI-Tests',
	#package : 'MooseCI-Tests'
}

{ #category : 'tests' }
MCIJSONReportWriterTest >> testJsonStringContainsMetricsAndViolations [

	| contents |
	contents := MCIJSONReportWriter new report: self report; jsonString.

	self assert: (contents includesSubstring: '"metrics"').
	self assert: (contents includesSubstring: '"violations"').
	self assert: (contents includesSubstring: 'File with too many LOC').
	self assert: (contents includesSubstring: 'main.py').
	self assert: (contents includesSubstring: 'FamixCBWarningSeverity')
]

{ #category : 'tests' }
MCIJSONReportWriterTest >> testJsonStringIsValidJson [

	| json metrics violations |
	json := STONJSON fromString: (MCIJSONReportWriter new report: self report; jsonString).

	metrics := json at: 'metrics'.
	self assert: (metrics at: 'files') equals: 3.
	self assert: (metrics at: 'loc') equals: 42.
	self assert: (metrics at: 'packages') equals: 2.
	self assert: (metrics at: 'classes') equals: 1.

	violations := (json at: 'violations') collect: [ :group | group asDictionary ].
	self assert: (violations first at: 'rule') equals: 'File with too many LOC'.
	self assert: (violations first at: 'severity') equals: 'FamixCBWarningSeverity'.
	self assert: (violations first at: 'count') equals: 2.
	self assert: ((violations first at: 'entities') includes: 'main.py')
]

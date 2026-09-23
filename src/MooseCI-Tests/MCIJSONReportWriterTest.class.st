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
]

{ #category : 'tests' }
MCIJSONReportWriterTest >> testJsonStringIsValidJson [

	| json metrics violations |
	json := STONJSON fromString: (MCIJSONReportWriter new report: report; jsonString).

	metrics := json at: 'metrics'.

	self assert: (metrics at: 'classes') isNumber.

	violations := (json at: 'violations') collect: [ :group | group asDictionary ].
	self assert: (violations first at: 'rule') isString.
	self assert: (#('Warning' 'Information' 'Error' 'Hint') includes: (violations first at: 'severity')).
	self assert: (violations first at: 'count') isNumber .
	self assert: (violations first at: 'entities') isArray
]

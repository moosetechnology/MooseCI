Class {
	#name : 'MCIJSONReportWriterTest',
	#superclass : 'MCIReportTestCase',
	#category : 'MooseCI-Tests',
	#package : 'MooseCI-Tests'
}

{ #category : 'tests' }
MCIJSONReportWriterTest >> testEntityObjectForAssociation [

	| get invocation object |
	get := MCIArchitectureRuleTest model allModelMethods detect: [ :method | method name = 'get' ].

	invocation := get outgoingInvocations detect: [ :each | each candidates anySatisfy: [ :candidate | candidate name = 'load' ] ].

	object := MCIJSONReportWriter new entityObject: invocation.

	self assert: (object at: 'entity') equals: 'get -> load'.
	self assert: ((object at: 'file') endsWith: 'Controller.java').
	self assert: (object at: 'startLine') isNumber.
	self assert: (object at: 'endLine') >= (object at: 'startLine')
]

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

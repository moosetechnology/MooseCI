Class {
	#name : 'MooseCIConfigTest',
	#superclass : 'TestCase',
	#category : 'MooseCI-Tests',
	#package : 'MooseCI-Tests'
}

{ #category : 'tests' }
MooseCIConfigTest >> testToSton [ 
	|stonString config|
	config := MooseCIConfig default.
	stonString := config toSton.
	
self assert: (stonString includesSubstring: 'MooseCIConfig').
self assert: (stonString includesSubstring: '#metrics').
self assert: (stonString includesSubstring: '#rules').
self assert: (stonString includesSubstring: '#ruleThresholds').
]

{ #category : 'tests' }
MooseCIConfigTest >> testDefaultConfigValid [

	| config |
	config := MooseCIConfig default.
	config projectPath: '/some/path'.

	self assert: config validationErrors isEmpty
]

{ #category : 'tests' }
MooseCIConfigTest >> testMissingProjectPath [

	| config |
	config := MooseCIConfig default.

	self assert: (config validationErrors includes: 'projectPath is not set')
]

{ #category : 'tests' }
MooseCIConfigTest >> testUnknownRule [

	| config errors |
	config := MooseCIConfig default.
	config projectPath: '/some/path'.
	config rules: #( #bogus_rule ).

	errors := config validationErrors.

	self assert: errors size equals: 1.
	self assert: (errors anySatisfy: [ :each | each includesSubstring: 'bogus_rule' ])
]

{ #category : 'tests' }
MooseCIConfigTest >> testAggregatedValidationErrors [

	| config errors |
	config := MooseCIConfig default.
	config rules: #( #bogus_rule #another_bogus_rule ).

	errors := config validationErrors.

	self assert: errors size equals: 3.
	self assert: (errors anySatisfy: [ :each | each includesSubstring: 'projectPath is not set' ])
]

{ #category : 'tests' }
MooseCIConfigTest >> testValidateSignalsError [

	| config |
	config := MooseCIConfig default.
	config rules: #( #bogus_rule ).

	self assertBlock: [ config validate ] raises: MooseCIConfigValidationError
]

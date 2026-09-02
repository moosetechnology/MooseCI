Class {
	#name : 'MooseCIConfigTest',
	#superclass : 'TestCase',
	#category : 'MooseCI-Tests',
	#package : 'MooseCI-Tests'
}

{ #category : 'tests' }
MooseCIConfigTest >> testAggregatedValidationErrors [

	| config errors |
	config := MooseCIConfig default.
	config rules: #( #unknown_rule #another_unknown_rule ).

	errors := config validationErrors.

	self assert: errors size equals: 3.
	self assert: (errors anySatisfy: [ :each | each includesSubstring: 'projectPath is not set' ])
]

{ #category : 'tests' }
MooseCIConfigTest >> testConfigForJavaIsValid [

	| config |
	config := MooseCIConfig for: #java.
	config projectPath: '/some/path'.
	config validate.
	self assert: config validationErrors isEmpty
]

{ #category : 'tests' }
MooseCIConfigTest >> testConfigForPythonIsValid [

	| config |
	config := MooseCIConfig for: #python.
	config projectPath: '/some/path'.
	config validate.
	self assert: config validationErrors isEmpty
]

{ #category : 'tests' }
MooseCIConfigTest >> testDefaultConfigValid [

	| config |
	config := MooseCIConfig default.
	config projectPath: '/some/path'.

	self assert: config validationErrors isEmpty
]

{ #category : 'tests' }
MooseCIConfigTest >> testForReturnsJavaConfig [

	| config |
	config := MooseCIConfig for: #java.

	self assert: config projectLanguage equals: #java.
	self assert: config rules equals: MCIQualityRules javaRules
]

{ #category : 'tests' }
MooseCIConfigTest >> testForReturnsPythonConfig [

	| config |
	config := MooseCIConfig for: #python.

	self assert: config projectLanguage equals: #python.
	self assert: config rules equals: MCIQualityRules pythonRules
]

{ #category : 'tests' }
MooseCIConfigTest >> testForUnknownLanguageSignalsError [

	self assertBlock: [ MooseCIConfig for: #ruby ] raises: Error
]

{ #category : 'tests' }
MooseCIConfigTest >> testGenericRuleValidForAnyLanguage [

	| config |
	config := MooseCIConfig default.
	config projectLanguage: #java.
	config projectPath: '/some/path'.
	config rules: #( #large_class ).
	
	self assert: config validationErrors isEmpty
]

{ #category : 'tests' }
MooseCIConfigTest >> testJavaDefaultConfig [

	| config |
	config := MooseCIConfig java.

	self assert: config projectLanguage equals: #java.
	self assert: config metrics equals: #( #size #complexity ).
	self assert: config outputPath equals: '.moose-ci/report'.
	self deny: config isRemote.
	self assert: config projectPath isNil
]

{ #category : 'tests' }
MooseCIConfigTest >> testMissingProjectPath [

	| config |
	config := MooseCIConfig default.

	self assert: (config validationErrors includes: 'projectPath is not set')
]

{ #category : 'tests' }
MooseCIConfigTest >> testPythonDefaultConfig [

	| config |
	config := MooseCIConfig python.

	self assert: config projectLanguage equals: #python.
	self assert: config metrics equals: #( #size #complexity ).
	self assert: config outputPath equals: '.moose-ci/report'.
	self deny: config isRemote.
	self assert: config projectPath isNil
]

{ #category : 'tests' }
MooseCIConfigTest >> testRuleNotApplicableToLanguageIsReported [

	| config |
	config := MooseCIConfig default.
	config projectLanguage: #java.
	config projectPath: '/some/path'.
	config rules: #( #no_docstring ).

	self assert: (config validationErrors includes: 'Rule #no_docstring is not applicable to language #java')
]

{ #category : 'tests' }
MooseCIConfigTest >> testToSton [ 
	|stonString config|
	config := MooseCIConfig default.
	stonString := config toSton.
	
self assert: (stonString includesSubstring: 'MooseCIConfig').
self assert: (stonString includesSubstring: '#metrics').
self assert: (stonString includesSubstring: '#rules').
]

{ #category : 'tests' }
MooseCIConfigTest >> testUnknownRule [

	| config errors |
	config := MooseCIConfig default.
	config projectPath: '/some/path'.
	config rules: #( #unknown_rule ).

	errors := config validationErrors.

	self assert: errors size equals: 1.
	self assert: (errors anySatisfy: [ :each | each includesSubstring: 'unknown_rule' ])
]

{ #category : 'tests' }
MooseCIConfigTest >> testValidateSignalsError [

	| config |
	config := MooseCIConfig default.
	config rules: #( #bogus_rule ).

	self assertBlock: [ config validate ] raises: MooseCIConfigValidationError
]

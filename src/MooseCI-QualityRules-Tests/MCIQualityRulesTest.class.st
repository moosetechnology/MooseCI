Class {
	#name : 'MCIQualityRulesTest',
	#superclass : 'TestCase',
	#category : 'MooseCI-QualityRules-Tests',
	#package : 'MooseCI-QualityRules-Tests'
}

{ #category : 'tests' }
MCIQualityRulesTest >> testAllRules [

	| rules |
	rules := MCIQualityRules allRules.

	self assert: rules size equals: MCIAbstractQualityRule subclasses size.
	self assert: (rules allSatisfy: [ :rule | rule superclass = MCIAbstractQualityRule  ]).
]

{ #category : 'tests' }
MCIQualityRulesTest >> testDefaultApplicableLanguagesIsAll [

	self assert: MCIAbstractQualityRule applicableLanguages equals: #all
]

{ #category : 'tests' }
MCIQualityRulesTest >> testJavaRulesOnlyContainGenericRules [

	| keys |
	keys := MCIQualityRules javaRules collect: [ :each |
			        each isAssociation ifTrue: [ each key ] ifFalse: [ each ] ].

	self assert: (keys allSatisfy: [ :key | (MCIQualityRules ruleAt: key) applicableLanguages = #all ])
]

{ #category : 'tests' }
MCIQualityRulesTest >> testPythonOnlyRulesDeclarePython [

	self assert: MCINoDocstringRule applicableLanguages equals: #( #python )
]

{ #category : 'tests' }
MCIQualityRulesTest >> testRuleAt [

	| rule |
	rule := MCIQualityRules ruleAt: #long_file.

	self assert: rule equals: MCILongFileRule
]

{ #category : 'tests' }
MCIQualityRulesTest >> testRuleAtNotFound [

	| rule |
	self assertBlock: [ rule := MCIQualityRules ruleAt: #a_non_existing_rule_key ] raises: MCIQualityRuleNotFoundError
]

{ #category : 'tests' }
MCIQualityRulesTest >> testRulesAt [

	| rules |
	rules := MCIQualityRules rulesAt: #(#long_file #no_docstring).

	self assert: rules size equals: 2.
	self assert: (rules allSatisfy: [ :rule | rule superclass = MCIAbstractQualityRule  ]).
]

Class {
	#name : 'MCIQualityRulesTest',
	#superclass : 'TestCase',
	#instVars : [
		'javaModel'
	],
	#category : 'MooseCI-QualityRules-Tests',
	#package : 'MooseCI-QualityRules-Tests'
}

{ #category : 'running' }
MCIQualityRulesTest >> setUp [
	super setUp.

	javaModel := FamixJavaModel new.
]

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
MCIQualityRulesTest >> testMCILargeClassRule [

	| javaViolations|
	
	javaModel newClassNamed: 'AJavaLargeClass'.
	
	javaViolations := MCIQualityRules runRules: { MCILargeClassRule new } on: javaModel.
	
	self assert: javaViolations isNotNil.
]

{ #category : 'tests' }
MCIQualityRulesTest >> testMCILongFileRule [

	| javaViolations|
	self flag: #TODO. 
	javaModel newClassNamed: 'AJavaLargeClass'.
	
	javaViolations := MCIQualityRules runRules: { MCILongFileRule new } on: javaModel.
	
	self assert: javaViolations isNotNil.
]

{ #category : 'tests' }
MCIQualityRulesTest >> testRuleAt [

	| aRuleClass |
	aRuleClass := MCIAbstractQualityRule subclasses first.


	self assert: (MCIQualityRules ruleAt: aRuleClass key) equals: aRuleClass
]

{ #category : 'tests' }
MCIQualityRulesTest >> testRuleAtNotFound [

	| rule |
	self assertBlock: [ rule := MCIQualityRules ruleAt: #a_non_existing_rule_key ] raises: MCIQualityRuleNotFoundError
]

{ #category : 'tests' }
MCIQualityRulesTest >> testRulesAt [

	| rules |
	rules := MCIAbstractQualityRule subclasses sliceTo: 2.

	self assert: rules size equals: 2.
	self assert: (rules allSatisfy: [ :rule | rule superclass = MCIAbstractQualityRule  ]).
]

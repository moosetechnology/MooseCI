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

	| javaViolations class method rule |
	class := FamixJavaClass new
		         name: 'AJavaLargeClass';
		         yourself.
	method := FamixJavaMethod new
		          name: 'aMethod';
		          yourself.
	class addMethod: method.

	javaModel
		add: method;
		add: class.
	rule := MCILargeClassRule new.
	rule threshold: 0.
	javaViolations := MCIQualityRules runRules: { rule } on: javaModel.

	self assert: javaViolations isNotNil
]

{ #category : 'tests' }
MCIQualityRulesTest >> testMCITooManyParametersRule [

	| javaViolations method rule param |
	method := FamixJavaMethod new
		          name: 'aMethod';
		          yourself.
	param := FamixJavaParameter new
		         name: 'aParam';
		         yourself.
	method addParameter: param.

	javaModel
		add: method;
		add: param.
	rule := MCITooManyParametersRule new.
	rule threshold: 0.
	javaViolations := MCIQualityRules runRules: { rule } on: javaModel.

	self assert: javaViolations isNotNil.
	self assert: javaViolations values first size equals: 1.
]

{ #category : 'tests' }
MCIQualityRulesTest >> testMCIUnusedLocalVariableRule [

	| javaViolations rule |
	
	javaModel add: (FamixJavaLocalVariable new
			 name: 'aVar';
			 yourself).
			
	rule := MCIUnusedLocalVariableRule new.
	
	javaViolations := MCIQualityRules runRules: { rule } on: javaModel.

	self assert: javaViolations isNotNil.
	self assert: javaViolations values first size equals: 1
]

{ #category : 'tests' }
MCIQualityRulesTest >> testMCIUnusedParameterRule [

	| javaViolations rule |
	
	(javaModel newMethodNamed: 'aMethod') addParameter: (FamixJavaParameter new
			 name: 'aParam';
			 yourself).

	rule := MCIUnusedParameterRule new.

	javaViolations := MCIQualityRules runRules: { rule } on: javaModel.

	self assert: javaViolations isNotNil.
	self assert: javaViolations values first size equals: 1
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

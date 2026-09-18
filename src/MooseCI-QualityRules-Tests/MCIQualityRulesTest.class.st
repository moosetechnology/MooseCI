Class {
	#name : 'MCIQualityRulesTest',
	#superclass : 'TestCase',
	#instVars : [
		'pyModel',
		'javaModel'
	],
	#category : 'MooseCI-QualityRules-Tests',
	#package : 'MooseCI-QualityRules-Tests'
}

{ #category : 'running' }
MCIQualityRulesTest >> setUp [
	super setUp.

	pyModel := FamixPythonModel new.
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
MCIQualityRulesTest >> testMCIFunctionNamingRule [

	| violations |
	
	pyModel newFunctionNamed: 'MyWrongNamedFunction'.
	violations := MCIQualityRules runRules: { MCIFunctionNamingRule new } on: pyModel.
	
	self assert: violations isNotEmpty
]

{ #category : 'tests' }
MCIQualityRulesTest >> testMCILargeClassRule [

	| pyViolations javaViolations|
	
	pyModel newClassNamed: 'APyLargeClass'.
	javaModel newClassNamed: 'AJavaLargeClass'.
	
	pyViolations := MCIQualityRules runRules: { MCILargeClassRule new } on: pyModel.
	javaViolations := MCIQualityRules runRules: { MCILargeClassRule new } on: javaModel.
	
	self assert: pyViolations isNotNil.
	self assert: javaViolations isNotNil.
]

{ #category : 'tests' }
MCIQualityRulesTest >> testMCILocalVariableNamingRule [

	| violations |
	
	pyModel newLocalVariableNamed: 'AWrongNamingForAVariable'.
	violations := MCIQualityRules runRules: { MCILocalVariableNamingRule new } on: pyModel.
	
	self assert: violations isNotEmpty
]

{ #category : 'tests' }
MCIQualityRulesTest >> testMCILongFileRule [

	| pyViolations javaViolations|
	self flag: #TODO. 
	pyModel newModuleNamed: 'aPythonModule'.
	javaModel newClassNamed: 'AJavaLargeClass'.
	
	pyViolations := MCIQualityRules runRules: { MCILongFileRule new } on: pyModel.
	javaViolations := MCIQualityRules runRules: { MCILongFileRule new } on: javaModel.
	self assert: pyViolations isNotNil.
	self assert: javaViolations isNotNil.
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

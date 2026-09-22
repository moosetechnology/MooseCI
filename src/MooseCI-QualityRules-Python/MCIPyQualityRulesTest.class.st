Class {
	#name : 'MCIPyQualityRulesTest',
	#superclass : 'TestCase',
	#instVars : [
		'model'
	],
	#category : 'MooseCI-QualityRules-Python',
	#package : 'MooseCI-QualityRules-Python'
}

{ #category : 'running' }
MCIPyQualityRulesTest >> setUp [
	super setUp.

	model := FamixPythonModel new.
]

{ #category : 'tests' }
MCIPyQualityRulesTest >> testMCIFunctionNamingRule [

	| violations |
	
	model newFunctionNamed: 'MyWrongNamedFunction'.
	violations := MCIQualityRules runRules: { MCIPyFunctionNamingRule new } on: model.
	
	self assert: violations isNotEmpty
]

{ #category : 'tests' }
MCIPyQualityRulesTest >> testMCILocalVariableNamingRule [

	| violations |
	
	model newLocalVariableNamed: 'AWrongNamingForAVariable'.
	violations := MCIQualityRules runRules: { MCIPyLocalVariableNamingRule new } on: model.
	
	self assert: violations isNotEmpty
]

{ #category : 'tests' }
MCIPyQualityRulesTest >> testMCIPyLongFileRule [

	| violations |
	
	model newModuleNamed: 'myModule'.
	violations := MCIQualityRules runRules: { MCIPyLongFileRule new } on: model.
	
	self assert: violations isNotEmpty
]

{ #category : 'tests' }
MCIPyQualityRulesTest >> testMCIPyNoDocstringRule [

	| violations |
	model
		newFunctionNamed: 'aFunction';
		newMethodNamed: 'aMethod';
		newClassNamed: 'AClass'.
	violations := MCIQualityRules runRules: { MCIPyNoDocstringRule new } on: model.

	self assert: violations isNotEmpty.
	self assert: violations values first size equals: 3.
]

{ #category : 'tests' }
MCIPyQualityRulesTest >> testMCIPyUnusedPrivateMethodRule [

	| violations |
	model newMethodNamed: '__a_private_method'.
	violations := MCIQualityRules runRules: { MCIPyUnusedPrivateMethodRule new } on: model.

	self assert: violations isNotEmpty.
	self assert: violations values first size equals: 1
]

{ #category : 'tests' }
MCIPyQualityRulesTest >> testPythonOnlyRulesDeclarePython [

	self assert: MCIPyNoDocstringRule applicableLanguages equals: #( #python )
]

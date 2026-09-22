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
MCIPyQualityRulesTest >> testPythonOnlyRulesDeclarePython [

	self assert: MCIPyNoDocstringRule applicableLanguages equals: #( #python )
]

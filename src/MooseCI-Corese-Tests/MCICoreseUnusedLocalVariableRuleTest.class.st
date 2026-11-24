"
The Corese rule subclasses another rule (MCIUnusedLocalVariableRule), not MCIAbstractQualityRule directly: it must still be found by its key.
"
Class {
	#name : 'MCICoreseUnusedLocalVariableRuleTest',
	#superclass : 'TestCase',
	#category : 'MooseCI-Corese-Tests',
	#package : 'MooseCI-Corese-Tests'
}

{ #category : 'tests' }
MCICoreseUnusedLocalVariableRuleTest >> testIsAcceptedInTheConfig [

	self assert: (STON fromString: 'MooseCIConfig {
	#projectLanguage : #java,
	#rules : [ #corese_unused_local_variable ],
	#isRemote : false
}') validationErrors isEmpty
]

{ #category : 'tests' }
MCICoreseUnusedLocalVariableRuleTest >> testIsFoundByItsKey [

	self assert: (MCIQualityRules ruleAt: #corese_unused_local_variable) equals: MCICoreseUnusedLocalVariableRule.
	self assert: (MCIQualityRules allRules includes: MCICoreseUnusedLocalVariableRule)
]

Class {
	#name : 'MCIQualityRules',
	#superclass : 'Object',
	#category : 'MooseCI-QualityRules',
	#package : 'MooseCI-QualityRules'
}

{ #category : 'instance creation' }
MCIQualityRules class >> allRules [

	^ MCIAbstractQualityRule subclasses
]

{ #category : 'helpers' }
MCIQualityRules class >> defaultRules [

	^ {
		  (MCILongFileRule key -> MCILongFileRule defaultThreshold).
		  MCINoDocstringRule key.
		  (MCITooManyParametersRule key -> MCITooManyParametersRule defaultThreshold).
		  (MCILargeClassRule key -> MCILargeClassRule defaultThreshold).
		  MCILocalVariableNamingRule key.
		  MCIUnusedLocalVariableRule key.
		  MCIUnusedParameterRule key.
		  MCIUnusedPrivateMethodRule key.
		  MCIShadowedAttributeRule key.
		  MCIFunctionNamingRule key }
]

{ #category : 'helpers' }
MCIQualityRules class >> javaRules [

	^ {
		  (MCILongFileRule key -> MCILongFileRule defaultThreshold).
		  (MCITooManyParametersRule key -> MCITooManyParametersRule defaultThreshold).
		  (MCILargeClassRule key -> MCILargeClassRule defaultThreshold).
		  MCILocalVariableNamingRule key.
		  MCIUnusedLocalVariableRule key.
		  MCIUnusedParameterRule key.
		  MCIUnusedPrivateMethodRule key.
		  MCIShadowedAttributeRule key.
		  MCIFunctionNamingRule key }
]

{ #category : 'helpers' }
MCIQualityRules class >> pythonRules [

	^ {
		  (MCILongFileRule key -> MCILongFileRule defaultThreshold).
		  MCINoDocstringRule key.
		  (MCITooManyParametersRule key -> MCITooManyParametersRule defaultThreshold).
		  (MCILargeClassRule key -> MCILargeClassRule defaultThreshold).
		  MCILocalVariableNamingRule key.
		  MCIUnusedLocalVariableRule key.
		  MCIUnusedParameterRule key.
		  MCIUnusedPrivateMethodRule key.
		  MCIShadowedAttributeRule key.
		  MCIFunctionNamingRule key }
]

{ #category : 'accessing' }
MCIQualityRules class >> ruleAt: aSymbol [

	MCIAbstractQualityRule subclasses
		detect: [ :ruleClass | ruleClass key = aSymbol ]
		ifFound: [ :ruleClass | ^ ruleClass ]
		ifNone: [ MCIQualityRuleNotFoundError signal: 'Rule not found: ' , aSymbol asString ]
]

{ #category : 'accessing' }
MCIQualityRules class >> rulesAt: aCollection [

	^ MCIAbstractQualityRule subclasses select: [ :rule | aCollection includes: rule key ]
]

{ #category : 'as yet unclassified' }
MCIQualityRules class >> runRules: aCollection on: aMooseModel [

	| criticModel |
	criticModel := MiCriticBrowserModel new.
	criticModel setEntities: aMooseModel.

	aCollection do: [ :rule |
			| context condition |
			context := rule context.
			condition := rule condition.
			
			criticModel addChildToRootContext: context.
			context addChild: condition.
			
			criticModel runCondition: condition 
			].
		
	^ criticModel violations
]

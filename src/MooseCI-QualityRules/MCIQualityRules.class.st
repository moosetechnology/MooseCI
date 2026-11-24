Class {
	#name : 'MCIQualityRules',
	#superclass : 'Object',
	#category : 'MooseCI-QualityRules',
	#package : 'MooseCI-QualityRules'
}

{ #category : 'accessing' }
MCIQualityRules class >> allRules [
	"All the rule classes, at any depth below MCIAbstractQualityRule"

	^ MCIAbstractQualityRule allSubclasses reject: [ :rule | rule isAbstract ]
]

{ #category : 'helpers' }
MCIQualityRules class >> defaultRules [

	^ {
		  (MCITooManyParametersRule key -> MCITooManyParametersRule defaultThresholds).
		  (MCILargeClassRule key -> MCILargeClassRule defaultThresholds).
		  MCIUnusedLocalVariableRule key.
		  MCIUnusedParameterRule key.
		  MCIShadowedAttributeRule key }
]

{ #category : 'as yet unclassified' }
MCIQualityRules class >> javaRules [

	^ {
		  (MCITooManyParametersRule key -> MCITooManyParametersRule defaultThresholds).
		  (MCILargeClassRule key -> MCILargeClassRule defaultThresholds).
		  MCIUnusedLocalVariableRule key.
		  MCIUnusedParameterRule key}
]

{ #category : 'accessing' }
MCIQualityRules class >> ruleAt: aSymbol [

	^ self allRules
		  detect: [ :ruleClass | ruleClass key = aSymbol ]
		  ifNone: [ MCIQualityRuleNotFoundError signal: 'Rule not found: ' , aSymbol asString ]
]

{ #category : 'accessing' }
MCIQualityRules class >> rulesAt: aCollection [

	^ self allRules select: [ :rule | aCollection includes: rule key ]
]

{ #category : 'as yet unclassified' }
MCIQualityRules class >> runRules: aCollection on: aMooseModel [

	| criticModel |
	criticModel := MiCriticBrowserModel new.
	criticModel setEntities: aMooseModel withoutStubs.

	aCollection do: [ :rule |
			| context |
			context := rule context.

			criticModel addChildToRootContext: context.
			(rule conditionsOn: aMooseModel) do: [ :condition |
					context addChild: condition.
					criticModel runCondition: condition ] ].

	^ criticModel violations
]

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

"
I get all attributes that duplicate their containing class name
"
Class {
	#name : 'MCIShadowedAttributeRule',
	#superclass : 'MCIAbstractQualityRule',
	#category : 'MooseCI-QualityRules',
	#package : 'MooseCI-QualityRules'
}

{ #category : 'accessing' }
MCIShadowedAttributeRule class >> defaultSeverity [

	^ FamixCBHintSeverity
]

{ #category : 'accessing' }
MCIShadowedAttributeRule class >> defaultThreshold [ 

	^ -1
]

{ #category : 'accessing' }
MCIShadowedAttributeRule class >> key [

	^ #shadowed_attribute
]

{ #category : 'accessing' }
MCIShadowedAttributeRule class >> ruleName [ 

	^ 'Attributes duplicate their containing class name'
]

{ #category : 'accessing' }
MCIShadowedAttributeRule >> contextFilterBlock [

	^ [ :collection | collection select: [ :each | each isAttribute ] ]
]

{ #category : 'accessing' }
MCIShadowedAttributeRule >> queryHandler [

	^ FamixCBQueryHandler on: (FQSelectScriptQuery script: [ :entity |
			   entity name isNotNil and: [ entity name asLowercase = entity parentType name asLowercase ] ])
]

"
I get all classes that have too many methods or attributes
"
Class {
	#name : 'MCILargeClassRule',
	#superclass : 'MCIAbstractQualityRule',
	#category : 'MooseCI-QualityRules',
	#package : 'MooseCI-QualityRules'
}

{ #category : 'accessing' }
MCILargeClassRule class >> defaultSeverity [

	^ FamixCBHintSeverity
]

{ #category : 'accessing' }
MCILargeClassRule class >> defaultThreshold [ 

	^ 20
]

{ #category : 'accessing' }
MCILargeClassRule class >> key [

	^ #large_class
]

{ #category : 'accessing' }
MCILargeClassRule class >> ruleName [ 

	^ 'Classes have too many methods or attributes'
]

{ #category : 'accessing' }
MCILargeClassRule >> contextFilterBlock [

	^ [ :collection | collection select: [ :each | each isClass ] ]
]

{ #category : 'accessing' }
MCILargeClassRule >> queryHandler [

	^ FamixCBQueryHandler on: (FQSelectScriptQuery script: [ :entity |
			   entity methods size > self threshold or: [ entity attributes size > 15 ] ])
]

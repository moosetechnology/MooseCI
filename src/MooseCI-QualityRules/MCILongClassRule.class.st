Class {
	#name : 'MCILongClassRule',
	#superclass : 'MCIAbstractQualityRule',
	#category : 'MooseCI-QualityRules',
	#package : 'MooseCI-QualityRules'
}

{ #category : 'accessing' }
MCILongClassRule class >> defaultThreshold [ 

	^ 1000
]

{ #category : 'accessing' }
MCILongClassRule class >> key [

	^ #long_class
]

{ #category : 'accessing' }
MCILongClassRule class >> ruleName [ 

	^ 'Long class'
]

{ #category : 'accessing' }
MCILongClassRule >> contextFilterBlock [

	^ [ :collection | collection select: [ :each | each isClass ] ]
]

{ #category : 'accessing' }
MCILongClassRule >> queryHandler [

	^ FamixCBQueryHandler on: (FQSelectScriptQuery script: [ :classEntity | classEntity numberOfLinesOfCode > self threshold ])
]

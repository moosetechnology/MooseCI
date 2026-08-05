"
I get all methods that have too many parameters
"
Class {
	#name : 'MCITooManyParametersRule',
	#superclass : 'MCIAbstractQualityRule',
	#category : 'MooseCI-QualityRules',
	#package : 'MooseCI-QualityRules'
}

{ #category : 'accessing' }
MCITooManyParametersRule class >> defaultSeverity [

	^ FamixCBWarningSeverity
]

{ #category : 'accessing' }
MCITooManyParametersRule class >> defaultThreshold [ 

	^ 10
]

{ #category : 'accessing' }
MCITooManyParametersRule class >> description [

	^ 'Reports methods whose number of parameters exceeds the threshold.'
]

{ #category : 'accessing' }
MCITooManyParametersRule class >> key [

	^ #too_many_parameters
]

{ #category : 'accessing' }
MCITooManyParametersRule class >> ruleName [ 

	^ 'Methods with too many parameters'
]

{ #category : 'accessing' }
MCITooManyParametersRule >> contextFilterBlock [

	^ [ :collection | collection select: [ :each | each isMethod ] ]
]

{ #category : 'accessing' }
MCITooManyParametersRule >> queryHandler [

	^ FamixCBQueryHandler on: (FQSelectScriptQuery script: [ :entity | entity parameters size > self threshold ])
]

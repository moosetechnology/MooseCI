"
I get all class-private methods that are never invoked
"
Class {
	#name : 'MCIUnusedPrivateMethodRule',
	#superclass : 'MCIAbstractQualityRule',
	#category : 'MooseCI-QualityRules',
	#package : 'MooseCI-QualityRules'
}

{ #category : 'accessing' }
MCIUnusedPrivateMethodRule class >> defaultSeverity [

	^ FamixCBHintSeverity
]

{ #category : 'accessing' }
MCIUnusedPrivateMethodRule class >> defaultThreshold [ 

	^ -1
]

{ #category : 'accessing' }
MCIUnusedPrivateMethodRule class >> key [

	^ #unused_private_method
]

{ #category : 'accessing' }
MCIUnusedPrivateMethodRule class >> ruleName [ 

	^ 'Unused class-private methods'
]

{ #category : 'accessing' }
MCIUnusedPrivateMethodRule >> contextFilterBlock [

	^ [ :collection |
	  collection select: [ :each |
		  each isMethod
			  and: [ each name matchesRegex: '^__[A-Za-z0-9]([A-Za-z0-9_]*[A-Za-z0-9])?_?$' ] ] ]
]

{ #category : 'accessing' }
MCIUnusedPrivateMethodRule >> queryHandler [

	^ FamixCBQueryHandler on: (FQSelectScriptQuery script: [ :entity |
			   entity incomingInvocations size = 0 ])
]

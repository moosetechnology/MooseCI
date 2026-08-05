"
I get all function and method parameters that are never read
"
Class {
	#name : 'MCIUnusedParameterRule',
	#superclass : 'MCIAbstractQualityRule',
	#category : 'MooseCI-QualityRules',
	#package : 'MooseCI-QualityRules'
}

{ #category : 'accessing' }
MCIUnusedParameterRule class >> defaultSeverity [

	^ FamixCBWarningSeverity
]

{ #category : 'accessing' }
MCIUnusedParameterRule class >> defaultThreshold [ 

	^ -1
]

{ #category : 'accessing' }
MCIUnusedParameterRule class >> description [

	^ 'Reports function and method parameters that are never used.'
]

{ #category : 'accessing' }
MCIUnusedParameterRule class >> key [

	^ #unused_parameter
]

{ #category : 'accessing' }
MCIUnusedParameterRule class >> ruleName [ 

	^ 'Unused function parameters'
]

{ #category : 'accessing' }
MCIUnusedParameterRule >> contextFilterBlock [

	^ [ :collection |
	  | functions params |
	  functions := collection select: [ :each | each isFunction or: [ each isMethod ] ].
	  params := ((functions select: [ :each | each parameters size > 0 ]) collect: [ :each | each parameters ]) flatCollect: [ :each | each ].
	  params ]
]

{ #category : 'accessing' }
MCIUnusedParameterRule >> queryHandler [

	^ FamixCBQueryHandler on: (FQSelectScriptQuery script: [ :param |
			   "ignore self, underscore and kwargs param"
			   (#( 'self' '_' 'kwargs') includes: param name) not
				   and: [ param incomingAccesses allSatisfy: [ :e | e isWrite ] ] ])
]

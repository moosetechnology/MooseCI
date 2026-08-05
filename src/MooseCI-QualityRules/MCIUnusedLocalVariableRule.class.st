"
I get all local variables that are only written but never read
"
Class {
	#name : 'MCIUnusedLocalVariableRule',
	#superclass : 'MCIAbstractQualityRule',
	#category : 'MooseCI-QualityRules',
	#package : 'MooseCI-QualityRules'
}

{ #category : 'accessing' }
MCIUnusedLocalVariableRule class >> defaultSeverity [

	^ FamixCBWarningSeverity
]

{ #category : 'accessing' }
MCIUnusedLocalVariableRule class >> defaultThreshold [ 

	^ -1
]

{ #category : 'accessing' }
MCIUnusedLocalVariableRule class >> key [

	^ #unused_local_variable
]

{ #category : 'accessing' }
MCIUnusedLocalVariableRule class >> ruleName [ 

	^ 'Unused local variables'
]

{ #category : 'accessing' }
MCIUnusedLocalVariableRule >> contextFilterBlock [

	^ [ :collection |
	  collection select: [ :each | each isLocalVariable and: [ each isStub not ] ] ]
]

{ #category : 'accessing' }
MCIUnusedLocalVariableRule >> queryHandler [

	^ FamixCBQueryHandler on: (FQSelectScriptQuery script: [ :entity |
			   entity incomingAccesses allSatisfy: [ :e | e isWrite ] ])
]

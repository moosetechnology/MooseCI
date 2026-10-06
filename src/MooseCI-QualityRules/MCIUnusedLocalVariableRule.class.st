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
MCIUnusedLocalVariableRule class >> description [

	^ 'Reports local variables that are written but never read.'
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

	^ [ :collection | collection select: [ :each | (each class usesTrait: FamixTLocalVariable) and: [ each isStub not ] ] ]
]

{ #category : 'accessing' }
MCIUnusedLocalVariableRule >> queryHandler [

	^ FamixCBQueryHandler on: (FQSelectScriptQuery script: [ :entity |
		"take all users of the variable and check if they use it only for writing => writing in it => the variable is unused (not read). And so for variable/object that didn't receive any invocation"
			   (entity incomingAccesses allSatisfy: [ :e | e isWrite ])
				   and: [ entity receivingInvocations isEmpty ]

			])
		
]

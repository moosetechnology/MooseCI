Class {
	#name : 'MCICoreseUnusedLocalVariableRule',
	#superclass : 'MCIUnusedLocalVariableRule',
	#category : 'MooseCI-Corese',
	#package : 'MooseCI-Corese'
}

{ #category : 'accessing' }
MCICoreseUnusedLocalVariableRule class >> key [

	^ #corese_unused_local_variable
]

{ #category : 'testing' }
MCICoreseUnusedLocalVariableRule >> isIgnored: anEntity [

	anEntity name ifNotNil: [ ^ #( 'ignored' ) includes: anEntity name ].
	^ false
]

{ #category : 'testing' }
MCICoreseUnusedLocalVariableRule >> queryHandler [

	^ FamixCBQueryHandler on: (FQSelectScriptQuery script: [ :entity |
			   ((entity incomingAccesses allSatisfy: [ :e | e isWrite ])
				   and: [ entity receivingInvocations isEmpty ]) and: [ (self isIgnored: entity) not ]

			])
		
]

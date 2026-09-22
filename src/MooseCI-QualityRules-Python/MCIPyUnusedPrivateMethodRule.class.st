"
I get all class-private methods that are never invoked
"
Class {
	#name : 'MCIPyUnusedPrivateMethodRule',
	#superclass : 'MCIAbstractQualityRule',
	#category : 'MooseCI-QualityRules-Python',
	#package : 'MooseCI-QualityRules-Python'
}

{ #category : 'as yet unclassified' }
MCIPyUnusedPrivateMethodRule class >> applicableLanguages [

	^ #( #python )
]

{ #category : 'accessing' }
MCIPyUnusedPrivateMethodRule class >> defaultSeverity [

	^ FamixCBHintSeverity
]

{ #category : 'accessing' }
MCIPyUnusedPrivateMethodRule class >> defaultThreshold [ 

	^ -1
]

{ #category : 'accessing' }
MCIPyUnusedPrivateMethodRule class >> description [

	^ 'Reports class-private methods that are never invoked.'
]

{ #category : 'accessing' }
MCIPyUnusedPrivateMethodRule class >> key [

	^ #unused_private_method
]

{ #category : 'accessing' }
MCIPyUnusedPrivateMethodRule class >> ruleName [ 

	^ 'Unused class-private methods'
]

{ #category : 'accessing' }
MCIPyUnusedPrivateMethodRule >> contextFilterBlock [

	^ [ :collection |
	  collection select: [ :each |
		  each isMethod
			  and: [ each name matchesRegex: '^__[A-Za-z0-9]([A-Za-z0-9_]*[A-Za-z0-9])?_?$' ] ] ]
]

{ #category : 'accessing' }
MCIPyUnusedPrivateMethodRule >> queryHandler [

	^ FamixCBQueryHandler on: (FQSelectScriptQuery script: [ :entity |
			   entity incomingInvocations size = 0 ])
]

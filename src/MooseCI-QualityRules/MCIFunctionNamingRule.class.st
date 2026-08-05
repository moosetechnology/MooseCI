"
I get all functions whose names don't comply with the naming convention
"
Class {
	#name : 'MCIFunctionNamingRule',
	#superclass : 'MCIAbstractQualityRule',
	#category : 'MooseCI-QualityRules',
	#package : 'MooseCI-QualityRules'
}

{ #category : 'accessing' }
MCIFunctionNamingRule class >> defaultSeverity [

	^ FamixCBHintSeverity
]

{ #category : 'accessing' }
MCIFunctionNamingRule class >> defaultThreshold [ 

	^ -1
]

{ #category : 'accessing' }
MCIFunctionNamingRule class >> description [

	^ 'Reports functions whose names do not comply with the naming convention.'
]

{ #category : 'accessing' }
MCIFunctionNamingRule class >> key [

	^ #function_naming
]

{ #category : 'accessing' }
MCIFunctionNamingRule class >> ruleName [ 

	^ 'Functions not respecting naming convention'
]

{ #category : 'accessing' }
MCIFunctionNamingRule >> contextFilterBlock [

	^ [ :collection |
	  collection select: [ :each |
		  each isFunction and: [ each isStub not and: [ each name isNotNil ] ] ] ]
]

{ #category : 'accessing' }
MCIFunctionNamingRule >> queryHandler [

	^ FamixCBQueryHandler on: (FQSelectScriptQuery script: [ :entity |
			   (entity name matchesRegex: '^[a-z_][a-z0-9_]*$') not ])
]

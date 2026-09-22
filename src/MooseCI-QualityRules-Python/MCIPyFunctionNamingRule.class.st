"
I get all functions whose names don't comply with the naming convention
"
Class {
	#name : 'MCIPyFunctionNamingRule',
	#superclass : 'MCIAbstractQualityRule',
	#category : 'MooseCI-QualityRules-Python',
	#package : 'MooseCI-QualityRules-Python'
}

{ #category : 'as yet unclassified' }
MCIPyFunctionNamingRule class >> applicableLanguages [

	^ #( #python )
]

{ #category : 'accessing' }
MCIPyFunctionNamingRule class >> defaultSeverity [

	^ FamixCBHintSeverity
]

{ #category : 'accessing' }
MCIPyFunctionNamingRule class >> defaultThreshold [ 

	^ -1
]

{ #category : 'accessing' }
MCIPyFunctionNamingRule class >> description [

	^ 'Reports functions whose names do not comply with the naming convention.'
]

{ #category : 'accessing' }
MCIPyFunctionNamingRule class >> key [

	^ #function_naming
]

{ #category : 'accessing' }
MCIPyFunctionNamingRule class >> ruleName [ 

	^ 'Functions not respecting naming convention'
]

{ #category : 'accessing' }
MCIPyFunctionNamingRule >> contextFilterBlock [

	^ [ :collection |
	  collection select: [ :each |
		  (each class usesTrait: FamixTFunction) and: [ each isStub not and: [ each name isNotNil ] ] ] ]
]

{ #category : 'accessing' }
MCIPyFunctionNamingRule >> queryHandler [

	^ FamixCBQueryHandler on: (FQSelectScriptQuery script: [ :entity |
			   (entity name matchesRegex: '^[a-z_][a-z0-9_]*$') not ])
]

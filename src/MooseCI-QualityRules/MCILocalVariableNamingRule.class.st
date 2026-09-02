"
I get all local variables and function parameters that don't respect the naming convention
"
Class {
	#name : 'MCILocalVariableNamingRule',
	#superclass : 'MCIAbstractQualityRule',
	#category : 'MooseCI-QualityRules',
	#package : 'MooseCI-QualityRules'
}

{ #category : 'as yet unclassified' }
MCILocalVariableNamingRule class >> applicableLanguages [

	^ #( #python )
]

{ #category : 'accessing' }
MCILocalVariableNamingRule class >> defaultSeverity [

	^ FamixCBWarningSeverity
]

{ #category : 'accessing' }
MCILocalVariableNamingRule class >> defaultThreshold [ 

	^ -1
]

{ #category : 'accessing' }
MCILocalVariableNamingRule class >> description [

	^ 'Reports local variables and parameters whose names do not respect the naming convention.'
]

{ #category : 'accessing' }
MCILocalVariableNamingRule class >> key [

	^ #local_var_naming
]

{ #category : 'accessing' }
MCILocalVariableNamingRule class >> ruleName [ 

	^ 'Local variables and parameters not respecting naming convention'
]

{ #category : 'accessing' }
MCILocalVariableNamingRule >> contextFilterBlock [

	^ [ :collection |
	  collection select: [ :each |
		  each isStub not
			  and: [ each name isNotNil
					  and: [ each isLocalVariable or: [ each class = FamixPythonParameter ] ] ] ] ]
]

{ #category : 'accessing' }
MCILocalVariableNamingRule >> queryHandler [

	^ FamixCBQueryHandler on: (FQSelectScriptQuery script: [ :entity |
			   (entity name matchesRegex: '^[_a-z][a-z0-9_]*$') not ])
]

"
I get all local variables and function parameters that don't respect the naming convention
"
Class {
	#name : 'MCIPyLocalVariableNamingRule',
	#superclass : 'MCIAbstractQualityRule',
	#category : 'MooseCI-QualityRules-Python',
	#package : 'MooseCI-QualityRules-Python'
}

{ #category : 'as yet unclassified' }
MCIPyLocalVariableNamingRule class >> applicableLanguages [

	^ #( #python )
]

{ #category : 'accessing' }
MCIPyLocalVariableNamingRule class >> defaultSeverity [

	^ FamixCBWarningSeverity
]

{ #category : 'accessing' }
MCIPyLocalVariableNamingRule class >> defaultThreshold [ 

	^ -1
]

{ #category : 'accessing' }
MCIPyLocalVariableNamingRule class >> description [

	^ 'Reports local variables and parameters whose names do not respect the naming convention.'
]

{ #category : 'accessing' }
MCIPyLocalVariableNamingRule class >> key [

	^ #local_var_naming
]

{ #category : 'accessing' }
MCIPyLocalVariableNamingRule class >> ruleName [ 

	^ 'Local variables and parameters not respecting naming convention'
]

{ #category : 'accessing' }
MCIPyLocalVariableNamingRule >> contextFilterBlock [

	^ [ :collection |
	  collection select: [ :each |
		  each isStub not
			  and: [ each name isNotNil
					  and: [ each isLocalVariable or: [ each class = FamixPythonParameter ] ] ] ] ]
]

{ #category : 'accessing' }
MCIPyLocalVariableNamingRule >> queryHandler [

	^ FamixCBQueryHandler on: (FQSelectScriptQuery script: [ :entity |
			   (entity name matchesRegex: '^[_a-z][a-z0-9_]*$') not ])
]

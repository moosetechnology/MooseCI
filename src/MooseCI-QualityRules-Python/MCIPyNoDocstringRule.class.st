"
I get all entities which don't have docstring
"
Class {
	#name : 'MCIPyNoDocstringRule',
	#superclass : 'MCIAbstractQualityRule',
	#category : 'MooseCI-QualityRules-Python',
	#package : 'MooseCI-QualityRules-Python'
}

{ #category : 'as yet unclassified' }
MCIPyNoDocstringRule class >> applicableLanguages [

	^ #( #python )
]

{ #category : 'accessing' }
MCIPyNoDocstringRule class >> defaultSeverity [

	^ FamixCBHintSeverity
]

{ #category : 'accessing' }
MCIPyNoDocstringRule class >> defaultThreshold [ 

	^ -1
]

{ #category : 'accessing' }
MCIPyNoDocstringRule class >> description [

	^ 'Reports functions, methods and classes that are missing a docstring.'
]

{ #category : 'accessing' }
MCIPyNoDocstringRule class >> key [

	^ #no_docstring
]

{ #category : 'accessing' }
MCIPyNoDocstringRule class >> ruleName [ 

	^ 'No docstring'
]

{ #category : 'accessing' }
MCIPyNoDocstringRule >> contextFilterBlock [
	"select functions, methods and classes"

	^ [ :collection |
	  (collection select: [ :each | 
		
		each isStub not and: [ 
			((each class usesTrait: FamixTFunction ) 
			or: [ each class usesTrait: FamixTMethod  ] )
			or: [ each isClass ] 
			
			] 
		
		
		]) asSet ]
]

{ #category : 'accessing' }
MCIPyNoDocstringRule >> queryHandler [

	^ FamixCBQueryHandler on: (FQSelectScriptQuery script: [ :entity |
			   entity comments isEmpty or: [ (entity comments anySatisfy: [ :each | each sourceText includesSubstring: '"""' ]) not ] ])
]

Class {
	#name : 'MCINoDocstringRule',
	#superclass : 'MCIAbstractQualityRule',
	#category : 'MooseCI-QualityRules',
	#package : 'MooseCI-QualityRules'
}

{ #category : 'accessing' }
MCINoDocstringRule class >> defaultSeverity [

	^ FamixCBHintSeverity
]

{ #category : 'accessing' }
MCINoDocstringRule class >> defaultThreshold [ 

	^ -1
]

{ #category : 'accessing' }
MCINoDocstringRule class >> key [

	^ #no_docstring
]

{ #category : 'accessing' }
MCINoDocstringRule class >> ruleName [ 

	^ 'No docstring'
]

{ #category : 'accessing' }
MCINoDocstringRule >> contextFilterBlock [

	^ [ :collection |
	  (collection select: [ :each | each isStub not and: [ each isFunction or: [ each isMethod or: [ each isClass ] ] ] ]) asSet ]
]

{ #category : 'accessing' }
MCINoDocstringRule >> queryHandler [

	^ FamixCBQueryHandler on: (FQSelectScriptQuery script: [ :entity |
			   entity comments isEmpty or: [ (entity comments anySatisfy: [ :each | each sourceText includesSubstring: '"""' ]) not ] ])
]

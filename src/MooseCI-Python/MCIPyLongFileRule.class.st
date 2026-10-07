"
I get all classes that have too many LOC
"
Class {
	#name : 'MCIPyLongFileRule',
	#superclass : 'MCIAbstractQualityRule',
	#category : 'MooseCI-Python-quality-rules',
	#package : 'MooseCI-Python',
	#tag : 'quality-rules'
}

{ #category : 'as yet unclassified' }
MCIPyLongFileRule class >> applicableLanguages [

	^ #( #python )
]

{ #category : 'accessing' }
MCIPyLongFileRule class >> defaultThresholds [

	^ { (#loc -> 1000) } asDictionary 
]

{ #category : 'accessing' }
MCIPyLongFileRule class >> description [

	^ 'Reports files whose number of lines of code exceeds the threshold.'
]

{ #category : 'accessing' }
MCIPyLongFileRule class >> key [

	^ #long_file
]

{ #category : 'accessing' }
MCIPyLongFileRule class >> ruleName [ 

	^ 'File with too many LOC'
]

{ #category : 'accessing' }
MCIPyLongFileRule >> contextFilterBlock [

	
	^ [ :collection | collection select: [ :each | each class usesTrait: FamixTModule ] ]
]

{ #category : 'accessing' }
MCIPyLongFileRule >> queryHandler [

	^ FamixCBQueryHandler on: (FQSelectScriptQuery script: [ :entity | entity numberOfLinesOfCode > (self thresholdAt: #loc) ])
]

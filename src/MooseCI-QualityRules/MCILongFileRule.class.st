"
I get all classes that have too many LOC
"
Class {
	#name : 'MCILongFileRule',
	#superclass : 'MCIAbstractQualityRule',
	#category : 'MooseCI-QualityRules',
	#package : 'MooseCI-QualityRules'
}

{ #category : 'accessing' }
MCILongFileRule class >> defaultThreshold [ 

	^ 1000
]

{ #category : 'accessing' }
MCILongFileRule class >> key [

	^ #long_file
]

{ #category : 'accessing' }
MCILongFileRule class >> ruleName [ 

	^ 'File with more too many LOC'
]

{ #category : 'accessing' }
MCILongFileRule >> contextFilterBlock [

	self flag: #TODO. "update to a standard file, not specifically for python"
	^ [ :collection | collection select: [ :each | each isModule ] ]
]

{ #category : 'accessing' }
MCILongFileRule >> queryHandler [

	^ FamixCBQueryHandler on: (FQSelectScriptQuery script: [ :entity | entity numberOfLinesOfCode > self threshold ])
]

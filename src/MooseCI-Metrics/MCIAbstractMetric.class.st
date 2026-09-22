"
I am the abstract base of the metrics of MooseCI.

A metric computes one numeric value from a Moose model.

New metrics (subclasses) must implement:
- `MCIAbstractMetric class >> #key`: unique identifier, e.g. `#loc`
- `MCIAbstractMetric >> #compute:`: compute the value from a Moose model

and may override `MCIAbstractMetric class >> #metricName`, `#description` and `#applicableLanguages`.
"
Class {
	#name : 'MCIAbstractMetric',
	#superclass : 'Object',
	#category : 'MooseCI-Metrics',
	#package : 'MooseCI-Metrics'
}

{ #category : 'testing' }
MCIAbstractMetric class >> applicableFor: aSymbol [

	| langs |
	langs := self applicableLanguages.
	(langs isSymbol and: [ langs = #all ]) ifTrue: [ ^ true ].

	^ langs includes: aSymbol
]

{ #category : 'accessing' }
MCIAbstractMetric class >> applicableLanguages [

	^ #all
]

{ #category : 'accessing' }
MCIAbstractMetric class >> description [

	^ self metricName
]

{ #category : 'accessing' }
MCIAbstractMetric class >> key [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
MCIAbstractMetric class >> metricName [

	^ self key asString
]

{ #category : 'accessing' }
MCIAbstractMetric >> applicableLanguages [

	^ #all
]

{ #category : 'computing' }
MCIAbstractMetric >> compute: aMooseModel [

	^ self subclassResponsibility
]

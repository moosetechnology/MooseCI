Class {
	#name : 'MCIMetrics',
	#superclass : 'Object',
	#category : 'MooseCI-Metrics',
	#package : 'MooseCI-Metrics'
}

{ #category : 'instance creation' }
MCIMetrics class >> allMetrics [

	^ MCIAbstractMetric subclasses
]

{ #category : 'computing' }
MCIMetrics class >> computeMetrics: aCollectionOfMetricKeys on: aMooseModel [

	| result |
	result := OrderedDictionary new.
	aCollectionOfMetricKeys do: [ :key |
		result at: key put: ((self metricAt: key) new compute: aMooseModel withoutStubs) ].
	^ result
]

{ #category : 'helpers' }
MCIMetrics class >> defaultMetrics [

	^ #( #classes )
]

{ #category : 'accessing' }
MCIMetrics class >> metricAt: aSymbol [

	MCIAbstractMetric subclasses
		detect: [ :metricClass | metricClass key = aSymbol ]
		ifFound: [ :metricClass | ^ metricClass ]
		ifNone: [ MCIMetricNotFoundError signal: 'Metric not found: ' , aSymbol asString ]
]

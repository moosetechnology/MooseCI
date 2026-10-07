"
I count the total lines of code of a model.
"
Class {
	#name : 'MCIPyLinesOfCodeMetric',
	#superclass : 'MCIAbstractMetric',
	#category : 'MooseCI-Python-metrics',
	#package : 'MooseCI-Python',
	#tag : 'metrics'
}

{ #category : 'accessing' }
MCIPyLinesOfCodeMetric class >> description [

	^ 'Total lines of code.'
]

{ #category : 'accessing' }
MCIPyLinesOfCodeMetric class >> key [

	^ #loc
]

{ #category : 'accessing' }
MCIPyLinesOfCodeMetric class >> metricName [

	^ 'LOC'
]

{ #category : 'computing' }
MCIPyLinesOfCodeMetric >> compute: aMooseModel [

	^ (aMooseModel allModules collect: [ :module | module sourceAnchor lineCount ]) sum
]

"
I count the total lines of code of a model.
"
Class {
	#name : 'MCILinesOfCodeMetric',
	#superclass : 'MCIAbstractMetric',
	#category : 'MooseCI-Metrics',
	#package : 'MooseCI-Metrics'
}

{ #category : 'accessing' }
MCILinesOfCodeMetric class >> description [

	^ 'Total lines of code.'
]

{ #category : 'accessing' }
MCILinesOfCodeMetric class >> key [

	^ #loc
]

{ #category : 'accessing' }
MCILinesOfCodeMetric class >> metricName [

	^ 'LOC'
]

{ #category : 'computing' }
MCILinesOfCodeMetric >> compute: aMooseModel [

	^ (aMooseModel allModules collect: [ :module | module sourceAnchor lineCount ]) sum
]

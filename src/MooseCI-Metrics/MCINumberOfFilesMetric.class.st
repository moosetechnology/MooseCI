"
I count the source files of a model.
"
Class {
	#name : 'MCINumberOfFilesMetric',
	#superclass : 'MCIAbstractMetric',
	#category : 'MooseCI-Metrics',
	#package : 'MooseCI-Metrics'
}

{ #category : 'accessing' }
MCINumberOfFilesMetric class >> description [

	^ 'Number of source files.'
]

{ #category : 'accessing' }
MCINumberOfFilesMetric class >> key [

	^ #files
]

{ #category : 'computing' }
MCINumberOfFilesMetric >> compute: aMooseModel [

	^ aMooseModel allModules size
]

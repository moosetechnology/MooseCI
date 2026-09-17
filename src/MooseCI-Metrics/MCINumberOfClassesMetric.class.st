"
I count the classes of a model.
"
Class {
	#name : 'MCINumberOfClassesMetric',
	#superclass : 'MCIAbstractMetric',
	#category : 'MooseCI-Metrics',
	#package : 'MooseCI-Metrics'
}

{ #category : 'accessing' }
MCINumberOfClassesMetric class >> description [

	^ 'Number of classes.'
]

{ #category : 'accessing' }
MCINumberOfClassesMetric class >> key [

	^ #classes
]

{ #category : 'computing' }
MCINumberOfClassesMetric >> compute: aMooseModel [

	^ aMooseModel allClasses size
]

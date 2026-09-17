"
I count the packages of a model.
"
Class {
	#name : 'MCINumberOfPackagesMetric',
	#superclass : 'MCIAbstractMetric',
	#category : 'MooseCI-Metrics',
	#package : 'MooseCI-Metrics'
}

{ #category : 'accessing' }
MCINumberOfPackagesMetric class >> description [

	^ 'Number of packages.'
]

{ #category : 'accessing' }
MCINumberOfPackagesMetric class >> key [

	^ #packages
]

{ #category : 'computing' }
MCINumberOfPackagesMetric >> compute: aMooseModel [

	^ aMooseModel allPackages size
]

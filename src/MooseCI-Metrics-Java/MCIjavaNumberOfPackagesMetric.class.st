"
I count the packages of a model.
"
Class {
	#name : 'MCIjavaNumberOfPackagesMetric',
	#superclass : 'MCIAbstractMetric',
	#category : 'MooseCI-Metrics-Java',
	#package : 'MooseCI-Metrics-Java'
}

{ #category : 'accessing' }
MCIjavaNumberOfPackagesMetric class >> applicableLanguages [

	^ #( #java )
]

{ #category : 'accessing' }
MCIjavaNumberOfPackagesMetric class >> description [

	^ 'Number of packages.'
]

{ #category : 'accessing' }
MCIjavaNumberOfPackagesMetric class >> key [

	^ #packages
]

{ #category : 'accessing' }
MCIjavaNumberOfPackagesMetric class >> metricName [ 

	^ 'Packages'
]

{ #category : 'computing' }
MCIjavaNumberOfPackagesMetric >> compute: aMooseModel [

	^ aMooseModel allPackages size
]

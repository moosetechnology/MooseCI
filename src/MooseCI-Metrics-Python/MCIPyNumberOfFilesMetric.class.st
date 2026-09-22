"
I count the source files of a model.
"
Class {
	#name : 'MCIPyNumberOfFilesMetric',
	#superclass : 'MCIAbstractMetric',
	#category : 'MooseCI-Metrics-Python',
	#package : 'MooseCI-Metrics-Python'
}

{ #category : 'accessing' }
MCIPyNumberOfFilesMetric class >> description [

	^ 'Number of source files.'
]

{ #category : 'accessing' }
MCIPyNumberOfFilesMetric class >> key [

	^ #files
]

{ #category : 'accessing' }
MCIPyNumberOfFilesMetric class >> metricName [ 

	^ 'Files'
]

{ #category : 'accessing' }
MCIPyNumberOfFilesMetric >> applicableLanguages [

	^ #( #python )
]

{ #category : 'computing' }
MCIPyNumberOfFilesMetric >> compute: aMooseModel [

	^ aMooseModel allModules size
]

"
I count the source files of a model.
"
Class {
	#name : 'MCIPyNumberOfFilesMetric',
	#superclass : 'MCIAbstractMetric',
	#category : 'MooseCI-Python-quality-rules',
	#package : 'MooseCI-Python',
	#tag : 'quality-rules'
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

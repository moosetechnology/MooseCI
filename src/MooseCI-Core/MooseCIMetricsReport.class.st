Class {
	#name : 'MooseCIMetricsReport',
	#superclass : 'Object',
	#instVars : [
		'files',
		'loc',
		'packages',
		'classes'
	],
	#category : 'MooseCI-Core',
	#package : 'MooseCI-Core'
}

{ #category : 'accessing' }
MooseCIMetricsReport >> classes [

	^ classes
]

{ #category : 'accessing' }
MooseCIMetricsReport >> classes: anObject [

	classes := anObject
]

{ #category : 'accessing' }
MooseCIMetricsReport >> files [

	^ files
]

{ #category : 'accessing' }
MooseCIMetricsReport >> files: anObject [

	files := anObject
]

{ #category : 'accessing' }
MooseCIMetricsReport >> loc [

	^ loc
]

{ #category : 'accessing' }
MooseCIMetricsReport >> loc: anObject [

	loc := anObject
]

{ #category : 'accessing' }
MooseCIMetricsReport >> packages [

	^ packages
]

{ #category : 'accessing' }
MooseCIMetricsReport >> packages: anObject [

	packages := anObject
]

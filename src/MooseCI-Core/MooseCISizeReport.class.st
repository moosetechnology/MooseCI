Class {
	#name : 'MooseCISizeReport',
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
MooseCISizeReport >> classes [

	^ classes
]

{ #category : 'accessing' }
MooseCISizeReport >> classes: anObject [

	classes := anObject
]

{ #category : 'accessing' }
MooseCISizeReport >> files [

	^ files
]

{ #category : 'accessing' }
MooseCISizeReport >> files: anObject [

	files := anObject
]

{ #category : 'accessing' }
MooseCISizeReport >> loc [

	^ loc
]

{ #category : 'accessing' }
MooseCISizeReport >> loc: anObject [

	loc := anObject
]

{ #category : 'accessing' }
MooseCISizeReport >> packages [

	^ packages
]

{ #category : 'accessing' }
MooseCISizeReport >> packages: anObject [

	packages := anObject
]

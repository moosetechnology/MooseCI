Class {
	#name : 'MCIVisualizationTest',
	#superclass : 'TestCase',
	#classInstVars : [
		'model'
	],
	#category : 'MooseCI-Visualisations-Tests',
	#package : 'MooseCI-Visualisations-Tests'
}

{ #category : 'accessing' }
MCIVisualizationTest class >> model [

	^ model ifNil: [ model := MooseCIJavaProjectLoader load: MooseCIBridge mockProjectTests / 'dependency-check' / 'example' ]
]

{ #category : 'accessing' }
MCIVisualizationTest >> model [

	^ self class model
]

{ #category : 'accessing' }
MCIVisualizationTest >> testClassesInRegex [

	| visualization |
	visualization := MCIVisualization new
		                 of: #classes;
		                 in: '.*\.ui\..*';
		                 yourself.

	self assert: ((visualization entitiesIn: self model) collect: #mooseName) asSet equals: #( #'example.ui.Controller' ) asSet
]

{ #category : 'accessing' }
MCIVisualizationTest >> testPackagesWithoutStubs [

	| visualization |
	visualization := MCIVisualization new
		                 of: #packages;
		                 yourself.

	self
		assert: ((visualization entitiesIn: self model) collect: #mooseName) asSet
		equals: #( #example #'example.ui' #'example.domain' #'example.infra' ) asSet
]

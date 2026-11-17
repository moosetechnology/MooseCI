Class {
	#name : 'MCIVisualizationTest',
	#superclass : 'TestCase',
	#classInstVars : [
		'model'
	],
	#category : 'MooseCI-Visualizations-Tests',
	#package : 'MooseCI-Visualizations-Tests'
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
MCIVisualizationTest >> testArchitecturalMapCanShowPackages [

	| visualization |
	visualization := MCIVisualization new
		                 view: #architecturalMap;
		                 of: #packages;
		                 yourself.
		
	self assert: (visualization canShowIn: self model)
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
MCIVisualizationTest >> testDsmCanShowClasses [

	| visualization |
	visualization := MCIVisualization new
		                 view: #dsm;
		                 of: #classes;
		                 yourself.
	self assert: (visualization canShowIn: self model)
]

{ #category : 'accessing' }
MCIVisualizationTest >> testExportArchitecturalMapToSvg [

	| file |
	file := FileSystem memory / 'out' / 'dsm.svg'.
	(MCIVisualization new
		 view: #architecturalMap;
		 of: #packages;
		 in: 'example\..+';
		 yourself) exportOn: self model to: file.

	self assert: (file contents beginsWith: '<?xml').
	self assert: (file contents includesSubstring: 'domain')
]

{ #category : 'accessing' }
MCIVisualizationTest >> testExportDsmToSvg [

	| file |
	file := FileSystem memory / 'out' / 'dsm.svg'.
	(MCIVisualization new
		 view: #dsm;
		 of: #classes;
		 yourself) exportOn: self model to: file.

	self assert: (file contents beginsWith: '<?xml').
	self assert: (file contents includesSubstring: 'Controller')
]

{ #category : 'accessing' }
MCIVisualizationTest >> testNewBrowserIsTheViewBrowser [

	self
		assert: (MCIVisualization new
				 view: #dsm;
				 yourself) newBrowser class
		equals: MiDSMBrowser.
		
	self
		assert: (MCIVisualization new
				 view: #architecturalMap;
				 yourself) newBrowser class
		equals: MiArchitecturalMapBrowser
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

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

{ #category : 'tests' }
MCIVisualizationTest >> testCoreWritesOneSvgPerVisualization [

	| directory core |
	directory := FileSystem memory / 'visualizations'.
	core := MooseCICore new
		        config: (MooseCIConfig new
				         visualizations: {
						         {
							         (#view -> #dsm).
							         (#of -> #classes) } asDictionary.
						         {
							         (#view -> #architecturalMap).
							         (#of -> #packages).
							         (#in -> 'example\..+') } asDictionary };
				         yourself);
		        model: self model;
		        yourself.

	core writeVisualizationsIn: directory.

	self assert: (directory children collect: #basename) asSet equals: #( '1-dsm-classes.svg' '2-architecturalMap-packages.svg' ) asSet
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

{ #category : 'tests' }
MCIVisualizationTest >> testFromDictionary [

	| visualization |
	visualization := MCIVisualization fromDictionary: {
			                 (#view -> #dsm).
			                 (#of -> #classes).
			                 (#in -> '.*\.ui\..*') } asDictionary.

	self assert: visualization newBrowser class equals: MiDSMBrowser.
	self assert: ((visualization entitiesIn: self model) collect: #mooseName) asArray equals: #( #'example.ui.Controller' )
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

{ #category : 'tests' }
MCIVisualizationTest >> testRunnerPrintsGenerationStepsThenFiles [

	| folder core output |
	folder := 'moose-ci-test-output'.
	core := MooseCICore new
		        config: (MooseCIConfig java
				         outputPath: folder;
				         visualizations: { {
						         (#view -> #dsm).
						         (#of -> #classes) } asDictionary };
				         yourself);
		        model: self model;
		        yourself.
	core runAnalysis.

	[
		output := String streamContents: [ :stream |
				          MooseCIRunner new
					          mooseCICore: core;
					          writeOutputOn: stream ] ] ensure: [ (FileLocator workingDirectory / folder) ensureDeleteAll ].

	self assert: (output indexOfSubCollection: 'Quality') < (output indexOfSubCollection: 'Generating report...').
	self assert: (output indexOfSubCollection: 'Generating report...') < (output indexOfSubCollection: 'Generating visualizations...').
	self assert: (output indexOfSubCollection: 'Generating visualizations...') < (output indexOfSubCollection: 'Files').
	self assert: (output includesSubstring: folder , '/visualizations/1-dsm-classes.svg')
]

{ #category : 'tests' }
MCIVisualizationTest >> testSettingsAreAppliedToTheBrowser [

	| browser |
	browser := (MCIVisualization fromDictionary: {
			            (#view -> #architecturalMap).
			            (#of -> #packages).
			            (#settings -> {
				             (#layout -> #tree).
				             (#weightedLinks -> true) } asDictionary) } asDictionary) newBrowser.

	self assert: browser specModel layout equals: RSTreeLayout.
	self assert: browser specModel weightedLinks
]

{ #category : 'tests' }
MCIVisualizationTest >> testWriteVisualizationsAnswersTheWrittenFiles [

	| directory files |
	directory := FileSystem memory / 'visualizations'.
	files := MooseCICore new
		         config: (MooseCIConfig new
				          visualizations: { {
						          (#view -> #dsm).
						          (#of -> #classes) } asDictionary };
				          yourself);
		         model: self model;
		         writeVisualizationsIn: directory.

	self assert: (files collect: #basename) asArray equals: #( '1-dsm-classes.svg' ).
	self assert: files first exists
]

Class {
	#name : 'MCIVisualization',
	#superclass : 'Object',
	#instVars : [
		'of',
		'in',
		'view',
		'settings'
	],
	#category : 'MooseCI-Visualizations',
	#package : 'MooseCI-Visualizations'
}

{ #category : 'accessing' }
MCIVisualization class >> fromDictionary: aDictionary [
	"An entry of #visualizations in moose-ci.ston, already validated by MooseCIConfig"

	^ self new
		  view: (aDictionary at: #view);
		  of: (aDictionary at: #of);
		  in: (aDictionary at: #in ifAbsent: [ nil ]);
		  settings: (aDictionary at: #settings ifAbsent: [ Dictionary new ]);
		  yourself
]

{ #category : 'as yet unclassified' }
MCIVisualization class >> kinds [

	^ {
		  (#packages -> FamixTPackage).
		  (#classes -> FamixTClass) } asDictionary
]

{ #category : 'accessing' }
MCIVisualization class >> layouts [

	^ {
		  (#flow -> RSFlowLayout).
		  (#circle -> RSCircleLayout).
		  (#grid -> RSGridLayout).
		  (#tree -> RSTreeLayout).
		  (#force -> MiForceBasedLayout) } asDictionary
]

{ #category : 'accessing' }
MCIVisualization class >> settings [
	"For each view, the settings of its MooseIDE browser that moose-ci.ston can set, with the accepted values (name in the ston -> value in the browser)"

	| booleans |
	booleans := {
		            (true -> true).
		            (false -> false) } asDictionary.
	^ {
		  (#architecturalMap -> {
			   (#layout -> self layouts).
			   (#weightedLinks -> booleans).
			   (#showDirectoriesAsRootNodes -> booleans).
			   (#hideMegamorphicInvocations -> booleans).
			   (#hideReceivedEntities -> booleans) } asDictionary).
		  (#dsm -> { (#shouldShowSelfDependencies -> booleans) } asDictionary) } asDictionary
]

{ #category : 'as yet unclassified' }
MCIVisualization class >> views [

	^ {
		  (#dsm -> MiDSMBrowser).
		  (#architecturalMap -> MiArchitecturalMapBrowser) } asDictionary
]

{ #category : 'private' }
MCIVisualization >> applySettingsTo: aBrowserModel [
	"Before following the entities, because updateFromConfiguration: redraws the browser"

	| configuration accepted |
	configuration := aBrowserModel currentConfiguration.
	accepted := self class settings at: view.
	settings keysAndValuesDo: [ :setting :value | configuration perform: setting asMutator with: ((accepted at: setting) at: value) ].
	aBrowserModel updateFromConfiguration: configuration
]

{ #category : 'testing' }
MCIVisualization >> canShowIn: aMooseModel [

	^ self newBrowser canFollowEntity: (self entitiesIn: aMooseModel)
]

{ #category : 'shapes' }
MCIVisualization >> entitiesIn: aMooseModel [

	| entities |
	entities := (aMooseModel allUsing: (self class kinds at: of)) reject: [ :each | each isStub ].

	in ifNotNil: [
			| module |
			module := DCLModuleOnMooseName new
				          description: in;
				          yourself.
			entities := entities select: [ :each | module descriptionMatches: each ] ].
		
	^ entities asMooseGroup
]

{ #category : 'as yet unclassified' }
MCIVisualization >> exportOn: aMooseModel to: aFileReference [

	| browser canvas |
	browser := self newBrowser.
	browser followEntity: (self entitiesIn: aMooseModel).

	canvas := RSCanvas new.
	browser mciVisualization buildInCanvas: canvas.

	aFileReference parent ensureCreateDirectory.

	RSSVGExporter new
		canvas: canvas;
		zoomToShapes;
		exportToFile: aFileReference
]

{ #category : 'accessing' }
MCIVisualization >> fileName [

	^ view , '-' , of , '.svg'
]

{ #category : 'instance creation' }
MCIVisualization >> in: aRegexString [

	in := aRegexString
]

{ #category : 'initialization' }
MCIVisualization >> initialize [

	super initialize.
	settings := Dictionary new
]

{ #category : 'accessing' }
MCIVisualization >> newBrowser [

	| browserClass browser |
	browserClass := self class views at: view.
	browser := browserClass newApplication: MiApplication current model: browserClass newModel.
	settings ifNotEmpty: [ self applySettingsTo: browser specModel ].
	^ browser
]

{ #category : 'instance creation' }
MCIVisualization >> of: aSymbol [

	of := aSymbol
]

{ #category : 'accessing' }
MCIVisualization >> settings: aDictionary [

	settings := aDictionary
]

{ #category : 'accessing' }
MCIVisualization >> view: aVizNameSymbol [

	view := aVizNameSymbol
]

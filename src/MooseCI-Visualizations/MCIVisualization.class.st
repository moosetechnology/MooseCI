Class {
	#name : 'MCIVisualization',
	#superclass : 'Object',
	#instVars : [
		'of',
		'in',
		'view'
	],
	#category : 'MooseCI-Visualizations',
	#package : 'MooseCI-Visualizations'
}

{ #category : 'as yet unclassified' }
MCIVisualization class >> kinds [

	^ {
		  (#packages -> FamixTPackage).
		  (#classes -> FamixTClass) } asDictionary
]

{ #category : 'as yet unclassified' }
MCIVisualization class >> views [

	^ {
		  (#dsm -> MiDSMBrowser).
		  (#architecturalMap -> MiArchitecturalMapBrowser) } asDictionary
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

{ #category : 'instance creation' }
MCIVisualization >> in: aRegexString [

	in := aRegexString
]

{ #category : 'instance creation' }
MCIVisualization >> newBrowser [

	| browserClass |
	browserClass := self class views at: view.
	
	^ browserClass newApplication: MiApplication current model: browserClass newModel
]

{ #category : 'instance creation' }
MCIVisualization >> of: aSymbol [

	of := aSymbol
]

{ #category : 'accessing' }
MCIVisualization >> view: aVizNameSymbol [

	view := aVizNameSymbol
]

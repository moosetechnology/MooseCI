Class {
	#name : 'MCIVisualization',
	#superclass : 'Object',
	#instVars : [
		'of',
		'in'
	],
	#category : 'MooseCI-Visualisations',
	#package : 'MooseCI-Visualisations'
}

{ #category : 'as yet unclassified' }
MCIVisualization class >> kinds [

	^ {
		  (#packages -> FamixTPackage).
		  (#classes -> FamixTClass) } asDictionary
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

{ #category : 'instance creation' }
MCIVisualization >> in: aRegexString [

	in := aRegexString
]

{ #category : 'instance creation' }
MCIVisualization >> of: aSymbol [

	of := aSymbol
]

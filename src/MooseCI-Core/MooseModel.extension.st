Extension { #name : 'MooseModel' }

{ #category : '*MooseCI-Core' }
MooseModel class >> possibleModelsToImportFromFiles [

	^ self withAllSubclasses reject: [ :model | model isDeprecated or: [ model canBeImportedFromFile not ] ]
]

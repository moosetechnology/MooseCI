Class {
	#name : 'MooseCICore',
	#superclass : 'Object',
	#instVars : [
		'model',
		'sizeReport',
		'criticModel',
		'violations'
	],
	#category : 'MooseCI-Core',
	#package : 'MooseCI-Core'
}

{ #category : 'accessing' }
MooseCICore >> criticModel [

	^ criticModel
]

{ #category : 'initialization' }
MooseCICore >> initialize [ 
	sizeReport := MooseCISizeReport new
]

{ #category : 'loading' }
MooseCICore >> loadProject: aProjectFilePath [
	model := FamixPythonImporter import: aProjectFilePath asFileReference.
	
]

{ #category : 'loading' }
MooseCICore >> runAnalysis [

	self runSizeAnalysis.
	self runCritics
]

{ #category : 'loading' }
MooseCICore >> runCritics [

	| criticBrowser |
	criticBrowser := MiCriticBrowser on: MiCriticBrowser newModel.
	'/Users/toky/Downloads/rules_1.ston' asFileReference readStreamDo: [ :stream | criticBrowser importRulesFromStream: stream ].
	criticBrowser specModel setEntities: model.
	criticBrowser specModel run.
	criticModel := criticBrowser specModel.
	violations := criticBrowser specModel violations
]

{ #category : 'loading' }
MooseCICore >> runSizeAnalysis [

	sizeReport files: model allModules size.
	sizeReport loc: (model allModules collect: [ :eachModule | eachModule sourceAnchor lineCount ]) sum.
	sizeReport packages: model allPackages size. 
	sizeReport classes: model allClasses size.
]

{ #category : 'accessing' }
MooseCICore >> sizeReport [

	^ sizeReport
]

{ #category : 'accessing' }
MooseCICore >> violations [

	^ violations
]

Class {
	#name : 'MooseCICore',
	#superclass : 'Object',
	#instVars : [
		'model',
		'criticModel',
		'violations',
		'metricsReport'
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
	metricsReport := MooseCISizeReport new
]

{ #category : 'loading' }
MooseCICore >> loadProject: aProjectFilePath [
	model := FamixPythonImporter import: aProjectFilePath asFileReference.
	
]

{ #category : 'accessing' }
MooseCICore >> metricsReport [

	^ metricsReport
]

{ #category : 'loading' }
MooseCICore >> runAnalysis [

	self runMetricsAnalysis.
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
MooseCICore >> runMetricsAnalysis [

	metricsReport files: model allModules size.
	metricsReport loc: (model allModules collect: [ :eachModule | eachModule sourceAnchor lineCount ]) sum.
	metricsReport packages: model allPackages size. 
	metricsReport classes: model allClasses size.
]

{ #category : 'accessing' }
MooseCICore >> violations [

	^ violations
]

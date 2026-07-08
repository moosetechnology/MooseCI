Class {
	#name : 'MooseCICore',
	#superclass : 'Object',
	#instVars : [
		'model',
		'criticModel',
		'violations',
		'metricsReport',
		'projectLanguage'
	],
	#category : 'MooseCI-Core',
	#package : 'MooseCI-Core'
}

{ #category : 'accessing' }
MooseCICore >> criticModel [

	^ criticModel
]

{ #category : 'accessing' }
MooseCICore >> criticModel: anObject [

	criticModel := anObject
]

{ #category : 'as yet unclassified' }
MooseCICore >> detectProjectLanguage: aDirectoryOrFileReference [

	projectLanguage := (MooseCILanguageDetector detect: aDirectoryOrFileReference) primary
]

{ #category : 'initialization' }
MooseCICore >> initialize [ 
	metricsReport := MooseCIMetricsReport new
]

{ #category : 'loading' }
MooseCICore >> loadProject: aProjectFilePath [

	| loader |
	self detectProjectLanguage: aProjectFilePath.
	
	loader := MooseCIProjectLoader forLanguage: projectLanguage.
	model := loader load: aProjectFilePath
]

{ #category : 'accessing' }
MooseCICore >> metricsReport [

	^ metricsReport
]

{ #category : 'accessing' }
MooseCICore >> metricsReport: anObject [

	metricsReport := anObject
]

{ #category : 'accessing' }
MooseCICore >> model [

	^ model
]

{ #category : 'accessing' }
MooseCICore >> model: anObject [

	model := anObject
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
	
	MooseCIBridge rules readStreamDo: [ :stream | criticBrowser importRulesFromStream: stream ].
	
	criticBrowser specModel setEntities: model.
	criticBrowser specModel run.
	criticModel := criticBrowser specModel.
	violations := criticBrowser specModel violations
]

{ #category : 'loading' }
MooseCICore >> runMetricsAnalysis [

	metricsReport files: model allModules size.
	metricsReport loc: (model allModules collect: [ :eachModule | eachModule sourceAnchor lineCount ]) sum.
	metricsReport packages: (model select: [ :each | each class = FamixPythonPackage ]) size.
	metricsReport classes: model allClasses size.
]

{ #category : 'accessing' }
MooseCICore >> violations [

	^ violations
]

{ #category : 'accessing' }
MooseCICore >> violations: anObject [

	violations := anObject
]

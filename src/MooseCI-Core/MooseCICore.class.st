Class {
	#name : 'MooseCICore',
	#superclass : 'Object',
	#instVars : [
		'model',
		'criticModel',
		'violations',
		'metrics',
		'projectLanguage',
		'projectPath',
		'config'
	],
	#category : 'MooseCI-Core',
	#package : 'MooseCI-Core'
}

{ #category : 'as yet unclassified' }
MooseCICore >> analysisReport [

	^ MCIAnalysisReport newFrom: config metrics: metrics violations: violations
]

{ #category : 'accessing' }
MooseCICore >> config [

	^ config
]

{ #category : 'accessing' }
MooseCICore >> config: aMooseCIConfig [

	config := aMooseCIConfig
]

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

	config projectLanguage: (MooseCILanguageDetector detect: aDirectoryOrFileReference) primary
]

{ #category : 'initialization' }
MooseCICore >> initialize [ 
	metrics := OrderedDictionary new
]

{ #category : 'loading' }
MooseCICore >> loadProject [

	| loader |
	self detectProjectLanguage: self projectPath.
	
	loader := MooseCIProjectLoader forLanguage: config projectLanguage.
	model := loader load: self projectPath
]

{ #category : 'accessing' }
MooseCICore >> metrics [

	^ metrics
]

{ #category : 'accessing' }
MooseCICore >> metrics: anObject [

	metrics := anObject
]

{ #category : 'accessing' }
MooseCICore >> model [

	^ model
]

{ #category : 'accessing' }
MooseCICore >> model: anObject [

	model := anObject
]

{ #category : 'accessing' }
MooseCICore >> projectPath [

	^ projectPath
]

{ #category : 'accessing' }
MooseCICore >> projectPath: anObject [

	projectPath := anObject
]

{ #category : 'loading' }
MooseCICore >> runAnalysis [

	self runMetricsAnalysis.
	self runCritics
]

{ #category : 'loading' }
MooseCICore >> runCritics [

	| rules |
	rules := config rules collect: [ :rule |
			         | mciQualityRule |
			         rule isAssociation
				         ifTrue: [
						         mciQualityRule := (MCIQualityRules ruleAt: rule key) new.
						         mciQualityRule threshold: rule value ]
				         ifFalse: [ mciQualityRule := (MCIQualityRules ruleAt: rule) new ].

			         mciQualityRule ].

	violations := MCIQualityRules runRules: rules on: model
]

{ #category : 'loading' }
MooseCICore >> runMetricsAnalysis [

	metrics := MCIMetrics computeMetrics: (config metrics ifNil: [ #(  ) ]) on: model
]

{ #category : 'accessing' }
MooseCICore >> violations [

	^ violations
]

{ #category : 'accessing' }
MooseCICore >> violations: anObject [

	violations := anObject
]

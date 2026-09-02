Class {
	#name : 'MooseCIConfig',
	#superclass : 'Object',
	#instVars : [
		'projectPath',
		'projectLanguage',
		'metrics',
		'rules',
		'outputFormats',
		'outputPath',
		'visualizations',
		'isRemote',
		'gitProjectUrl'
	],
	#category : 'MooseCI-Core',
	#package : 'MooseCI-Core'
}

{ #category : 'accessing' }
MooseCIConfig class >> configFileName [

	^ 'moose-ci.ston'
]

{ #category : 'accessing' }
MooseCIConfig class >> default [

	^ self new
		  projectPath: nil;
		  projectLanguage: nil;
		  metrics: #( #size #complexity );
		  rules: MCIQualityRules defaultRules;
		  visualizations: #(  );
		  outputFormats: MCIReportWriter defaultOutputFormats;
		  outputPath: '.moose-ci/report';
		  isRemote: false;
		  yourself
]

{ #category : 'instance creation' }
MooseCIConfig class >> for: aSymbol [

	| configs |
	configs := {
		           (#java -> self java).
		           (#python -> self python) } asOrderedDictionary.

	^ configs at: aSymbol ifAbsent: [ Error signal: 'Default config not found for: ' , aSymbol asString ]
]

{ #category : 'accessing' }
MooseCIConfig class >> java [

	^ self new
		  projectPath: nil;
		  projectLanguage: #java;
		  metrics: #( #size #complexity );
		  rules: MCIQualityRules javaRules;
		  visualizations: #(  );
		  outputFormats: MCIReportWriter defaultOutputFormats;
		  outputPath: '.moose-ci/report';
		  isRemote: false;
		  yourself
]

{ #category : 'accessing' }
MooseCIConfig class >> python [

	^ self new
		  projectPath: nil;
		  projectLanguage: #python;
		  metrics: #( #size #complexity );
		  rules: MCIQualityRules pythonRules;
		  visualizations: #(  );
		  outputFormats: MCIReportWriter defaultOutputFormats;
		  outputPath: '.moose-ci/report';
		  isRemote: false;
		  yourself
]

{ #category : 'validation' }
MooseCIConfig >> checkProjectLanguageInto: errors [

	projectLanguage isNil ifTrue: [ ^ self ].
	(MooseCILanguageDetector extensionMap values includes: projectLanguage) ifFalse: [
		errors add: 'Unsupported project language: ' , projectLanguage asString ]
]

{ #category : 'validation' }
MooseCIConfig >> checkProjectPathInto: errors [

	(isRemote not and: [ projectPath isNil ]) ifTrue: [ errors add: 'projectPath is not set' ].
	(isRemote and: [ gitProjectUrl isNil ]) ifTrue: [ errors add: 'gitProjectUrl is not set' ]
]

{ #category : 'validation' }
MooseCIConfig >> checkRuleSymbol: aSymbol into: errors [

	aSymbol isSymbol ifFalse: [ errors add: 'rules entries must be rule keys (Symbols)' ].

	aSymbol isSymbol ifTrue: [
		((MCIAbstractQualityRule subclasses collect: #key) includes: aSymbol) ifFalse: [ errors add: 'Unknown rule: ' , aSymbol asString ] ]
]

{ #category : 'validation' }
MooseCIConfig >> checkRulesInto: errors [

	rules ifNil: [
			errors add: 'rules must not be empty'.
			^ errors ].

	rules isCollection ifFalse: [
			errors add: 'rules must be a collection'.
			^ errors ].

	rules isEmpty ifTrue: [
			errors add: 'rules must not be empty'.
			^ errors ].

	rules do: [ :each |
			| key threshold |
			key := each isAssociation
				       ifTrue: [
						       each key.
						       threshold := each value.
						       self checkThresholdValue: each into: errors ]
				       ifFalse: [ self checkRuleSymbol: each into: errors ] ]
]

{ #category : 'validation' }
MooseCIConfig >> checkThresholdValue: anAssociation into: errors [

	| threshold |
	self checkRuleSymbol: anAssociation key into: errors.
	threshold := anAssociation value.
	threshold isNumber ifFalse: [ errors add: 'Threshold for ' , anAssociation key , ' must be a number' ].
]

{ #category : 'accessing' }
MooseCIConfig >> gitProjectUrl [

	^ gitProjectUrl
]

{ #category : 'accessing' }
MooseCIConfig >> gitProjectUrl: aString [

	gitProjectUrl := aString
]

{ #category : 'accessing' }
MooseCIConfig >> isRemote [

	^ isRemote
]

{ #category : 'accessing' }
MooseCIConfig >> isRemote: aBoolean [

	isRemote := aBoolean
]

{ #category : 'accessing' }
MooseCIConfig >> metrics [

	^ metrics
]

{ #category : 'accessing' }
MooseCIConfig >> metrics: anArray [

	metrics := anArray
]

{ #category : 'accessing' }
MooseCIConfig >> outputFormats [

	^ outputFormats
]

{ #category : 'accessing' }
MooseCIConfig >> outputFormats: anArray [

	outputFormats := anArray
]

{ #category : 'accessing' }
MooseCIConfig >> outputPath [

	^ outputPath
]

{ #category : 'accessing' }
MooseCIConfig >> outputPath: aString [

	outputPath := aString
]

{ #category : 'accessing' }
MooseCIConfig >> projectLanguage [

	^ projectLanguage
]

{ #category : 'accessing' }
MooseCIConfig >> projectLanguage: aSymbol [

	projectLanguage := aSymbol
]

{ #category : 'accessing' }
MooseCIConfig >> projectPath [

	^ projectPath
]

{ #category : 'accessing' }
MooseCIConfig >> projectPath: aString [

	projectPath := aString
]

{ #category : 'accessing' }
MooseCIConfig >> rules [

	^ rules
]

{ #category : 'accessing' }
MooseCIConfig >> rules: anArray [

	rules := anArray
]

{ #category : 'as yet unclassified' }
MooseCIConfig >> toSton [

	^ STON toStringPretty: self
]

{ #category : 'validation' }
MooseCIConfig >> validate [

	| errors |
	errors := self validationErrors.
	errors ifNotEmpty: [ MooseCIConfigValidationError signal: errors ]
]

{ #category : 'validation' }
MooseCIConfig >> validationErrors [

	| errors |
	errors := OrderedCollection new.
	self checkProjectPathInto: errors.
	self checkRulesInto: errors.
	self checkProjectLanguageInto: errors.
	^ errors
]

{ #category : 'accessing' }
MooseCIConfig >> visualizations [

	^ visualizations
]

{ #category : 'accessing' }
MooseCIConfig >> visualizations: anArray [

	visualizations := anArray
]

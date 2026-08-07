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
		  outputFormats: #( #html );
		  outputPath: '.moose-ci/report';
		  isRemote: false;
		  yourself
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
MooseCIConfig >> checkRuleThresholdsInto: errors [

	ruleThresholds isNil ifTrue: [ ^ self ].
	ruleThresholds keysAndValuesDo: [ :key :value |
		value isNumber ifFalse: [
			errors add: 'Threshold for ' , key asString , ' must be a number' ] ]
]

{ #category : 'validation' }
MooseCIConfig >> checkRulesInto: errors [

	rules isNil ifTrue: [ ^ errors add: 'rules must not be empty' ].
	rules isCollection ifFalse: [ ^ errors add: 'rules must be a collection' ].
	rules isEmpty ifTrue: [ ^ errors add: 'rules must not be empty' ].

	rules do: [ :each |
		| key |
		key := each isAssociation ifTrue: [ each key ] ifFalse: [ each ].
		key isSymbol ifFalse: [ errors add: 'rules entries must be rule keys (Symbols)' ].
		key isSymbol ifTrue: [
			((MCIAbstractQualityRule subclasses collect: #key) includes: key) ifFalse: [
				errors add: 'Unknown rule: ' , key asString ] ] ]
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
	self checkRuleThresholdsInto: errors.
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

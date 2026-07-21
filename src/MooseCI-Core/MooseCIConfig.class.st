Class {
	#name : 'MooseCIConfig',
	#superclass : 'Object',
	#instVars : [
		'projectPath',
		'projectLanguage',
		'metrics',
		'rules',
		'ruleThresholds',
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
		  rules: #( #maxClassLoc #maxMethods #maxParams #maxCyclomatic #cyclicDependencies #clones );
		  ruleThresholds: self defaultThresholds;
		  visualizations: #(  );
		  outputFormats: #( #html );
		  outputPath: '.moose-ci/report';
		  isRemote: false;
		  yourself
]

{ #category : 'accessing' }
MooseCIConfig class >> defaultThresholds [

	^ Dictionary new
		  at: #maxClassLoc put: 1000;
		  at: #maxMethods put: 50;
		  at: #maxParams put: 5;
		  at: #maxCyclomatic put: 10;
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
MooseCIConfig >> ruleThresholds [

	^ ruleThresholds
]

{ #category : 'accessing' }
MooseCIConfig >> ruleThresholds: aDictionary [

	ruleThresholds := aDictionary
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

	self flag: #TODO
]

{ #category : 'accessing' }
MooseCIConfig >> visualizations [

	^ visualizations
]

{ #category : 'accessing' }
MooseCIConfig >> visualizations: anArray [

	visualizations := anArray
]

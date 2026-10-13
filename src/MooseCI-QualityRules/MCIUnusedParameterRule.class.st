"
I get all function and method parameters that are never read
"
Class {
	#name : 'MCIUnusedParameterRule',
	#superclass : 'MCIAbstractQualityRule',
	#category : 'MooseCI-QualityRules',
	#package : 'MooseCI-QualityRules'
}

{ #category : 'accessing' }
MCIUnusedParameterRule class >> defaultSeverity [

	^ FamixCBWarningSeverity
]

{ #category : 'accessing' }
MCIUnusedParameterRule class >> description [

	^ 'Reports function and method parameters that are never used.'
]

{ #category : 'accessing' }
MCIUnusedParameterRule class >> key [

	^ #unused_parameter
]

{ #category : 'accessing' }
MCIUnusedParameterRule class >> ruleName [ 

	^ 'Unused function parameters'
]

{ #category : 'accessing' }
MCIUnusedParameterRule >> contextFilterBlock [

	^ [ :collection |
		  | functions params |
		  functions := collection select: [ :each | ((each class usesTrait: FamixTFunction) or: [ each class usesTrait: FamixTMethod ]) and: [ (self isContractMethod: each) not ] ].
		
		  params := ((functions select: [ :each | each parameters isNotEmpty ]) collect: [ :each | each parameters ]) flatCollect: [ :each | each ].
		  params
		
		
		]
]

{ #category : 'testing' }
MCIUnusedParameterRule >> isContractMethod: aBehaviouralEntity [
	"true for a method whose params are imposed by a java contract (interfaces, overriden method).
so we don't report them"

	| parentType |
	"skip it if it's not java or a language that doesn't has parentType"
	(aBehaviouralEntity respondsTo: #parentType) ifFalse: [ ^ false ].
	parentType := aBehaviouralEntity parentType.
	parentType ifNil: [ ^ false ].

	(aBehaviouralEntity respondsTo: #isMethodDefinition) ifFalse: [ ^ false ].
	aBehaviouralEntity isMethodDefinition ifFalse: [ ^ true ].

	((aBehaviouralEntity respondsTo: #overridenMethod) and: [ parentType respondsTo: #isInterface ]) ifFalse: [ ^ false ].

	parentType isInterface ifTrue: [ ^ false ].

	^ aBehaviouralEntity overriddenMethod isNotNil
]

{ #category : 'accessing' }
MCIUnusedParameterRule >> queryHandler [

	^ FamixCBQueryHandler on: (FQSelectScriptQuery script: [ :param |
			   "ignore self, underscore and kwargs param"
			   (#( 'self' '_' 'kwargs') includes: param name) not
				   and: [ param incomingAccesses allSatisfy: [ :e | e isWrite ] ] ])
]

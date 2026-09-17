"
A MooseCICoreTest is a test class for testing the behavior of MooseCICore
"
Class {
	#name : 'MooseCICoreTest',
	#superclass : 'TestCase',
	#instVars : [
		'mooseCICore'
	],
	#category : 'MooseCI-Tests',
	#package : 'MooseCI-Tests'
}

{ #category : 'running' }
MooseCICoreTest >> setUp [
	super setUp.

	mooseCICore := MooseCICore new.
	
	mooseCICore config: MooseCIConfig default.
	
]

{ #category : 'tests' }
MooseCICoreTest >> testLoadProject [

	
	mooseCICore projectPath: MooseCIBridge mockProjectTests / 'one-lang'.
	
	mooseCICore loadProject.

	self assert: mooseCICore model isMooseModel
]

{ #category : 'tests' }
MooseCICoreTest >> testLoadProjectJava [

	| projectPath |
	projectPath := MooseCIBridge mockProjectTests / 'java-only'.
	mooseCICore projectPath: projectPath.
	mooseCICore loadProject.

	self assert: mooseCICore model isMooseModel.
	self assert: (mooseCICore model isKindOf: FamixJavaModel)
]

{ #category : 'tests' }
MooseCICoreTest >> testRunCritics [

	mooseCICore projectPath: MooseCIBridge mockProjectTests / 'one-lang'.
	mooseCICore loadProject.
	mooseCICore runCritics.

	self assert: mooseCICore violations isNotNil.
	self assert: mooseCICore violations isDictionary.
	self assert: mooseCICore violations size equals: mooseCICore config rules size.
	self
		assert: (mooseCICore violations keys collect: [ :condition | condition name ]) asSet
		equals: (mooseCICore config rules collect: [ :configRule |
					 configRule isAssociation
						 ifTrue: [ (MCIQualityRules ruleAt: configRule key) new name ]
						 ifFalse: [ (MCIQualityRules ruleAt: configRule) new name ] ]) asSet
]

{ #category : 'tests' }
MooseCICoreTest >> testRunCriticsWithCustomConfigThreshold [

	| rules |
	rules := { (MCILongFileRule key -> 1) }.

	mooseCICore projectPath: MooseCIBridge mockProjectTests / 'one-lang'.
	mooseCICore config rules: rules.
	mooseCICore loadProject.
	mooseCICore runCritics.
	
	self assert: mooseCICore violations isNotNil.
	self assert: mooseCICore violations isDictionary.
	self assert: mooseCICore violations values first size equals: 1.
	self assert: mooseCICore violations values first allViolatingEntitiesType asArray first equals: FamixPythonModule
]

{ #category : 'tests' }
MooseCICoreTest >> testRunMetricsAnalysis [

	mooseCICore projectPath: MooseCIBridge mockProjectTests / 'one-file'.
	mooseCICore loadProject.
	mooseCICore runMetricsAnalysis.
	
	self assert: mooseCICore metrics class equals: OrderedDictionary.
	self assert: (mooseCICore metrics at: #loc) equals: 1.
	self assert: (mooseCICore metrics at: #packages) equals: 1.
	self assert: (mooseCICore metrics at: #classes) equals: 0.
	
]

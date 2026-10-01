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
	
	mooseCICore config: MooseCIConfig java.
	
]

{ #category : 'tests' }
MooseCICoreTest >> testLoadProject [

	| projectPath |
	projectPath := MooseCIBridge mockProjectTests / 'java-only'.
	mooseCICore projectPath: projectPath.
	mooseCICore loadProject.

	self assert: mooseCICore model isMooseModel.
	self assert: (mooseCICore model isKindOf: FamixJavaModel)
]

{ #category : 'tests' }
MooseCICoreTest >> testRunCritics [

	mooseCICore projectPath: MooseCIBridge mockProjectTests / 'java-only'.
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
	rules := { (MCILargeClassRule key -> 1) }.

	mooseCICore projectPath: MooseCIBridge mockProjectTests / 'java-only'.
	mooseCICore config rules: rules.
	mooseCICore loadProject.
	mooseCICore runCritics.
	
	self assert: mooseCICore violations isNotNil.
	self assert: mooseCICore violations isDictionary.
	self assert: mooseCICore violations values first size equals: 2.
	self assert: mooseCICore violations values first allViolatingEntitiesType asArray first equals: FamixJavaClass 
]

{ #category : 'tests' }
MooseCICoreTest >> testRunMetricsAnalysis [

	mooseCICore projectPath: MooseCIBridge mockProjectTests / 'java-only'.
	mooseCICore config: MooseCIConfig java.
	mooseCICore loadProject.
	mooseCICore runMetricsAnalysis.
	
	self assert: mooseCICore metrics isDictionary.
	self assert: (mooseCICore metrics at: #classes) isNumber.
	
]

{ #category : 'tests' }
MooseCICoreTest >> testRunMetricsAnalysisWithEmptyMetrics [

	mooseCICore projectPath: MooseCIBridge mockProjectTests / 'java-only'.
	mooseCICore config metrics: #(  ).
	mooseCICore loadProject.
	mooseCICore runMetricsAnalysis.

	self assert: mooseCICore metrics isEmpty
]

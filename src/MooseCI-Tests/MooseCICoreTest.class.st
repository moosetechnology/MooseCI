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

	
	mooseCICore config projectPath: MooseCIBridge mockProjectTests / 'one-lang'.
	
	mooseCICore loadProject.

	self assert: mooseCICore model isMooseModel
]

{ #category : 'tests' }
MooseCICoreTest >> testRunCritics [

	mooseCICore config projectPath: MooseCIBridge mockProjectTests / 'one-lang'.
	mooseCICore loadProject.
	mooseCICore runCritics.
	
	self assert: mooseCICore violations isNotNil.
	self assert: mooseCICore violations isDictionary.
	self assert: mooseCICore violations size equals: mooseCICore config rules size.
	self assert: (mooseCICore violations keys collect: [ :condition | condition name ]) asSet
		equals: (mooseCICore config rules collect: [ :ruleKey | (MCIQualityRules ruleAt: ruleKey) new name ]) asSet
]

{ #category : 'tests' }
MooseCICoreTest >> testRunMetricsAnalysis [

	mooseCICore config projectPath: MooseCIBridge mockProjectTests / 'one-file'.
	mooseCICore loadProject.
	mooseCICore runMetricsAnalysis.
	
	self assert: mooseCICore metricsReport class equals: MooseCIMetricsReport.
	self assert: mooseCICore metricsReport loc equals: 1.
	self assert: mooseCICore metricsReport packages equals: 1.
	self assert: mooseCICore metricsReport classes equals: 0.
	
]

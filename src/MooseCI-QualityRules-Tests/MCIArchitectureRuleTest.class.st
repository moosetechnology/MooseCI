Class {
	#name : 'MCIArchitectureRuleTest',
	#superclass : 'TestCase',
	#classInstVars : [
		'model'
	],
	#category : 'MooseCI-QualityRules-Tests',
	#package : 'MooseCI-QualityRules-Tests'
}

{ #category : 'accessing' }
MCIArchitectureRuleTest class >> model [

	^ model ifNil: [ model := MooseCIJavaProjectLoader load: MooseCIBridge mockProjectTests / 'dependency-check' / 'example' ]
]

{ #category : 'accessing' }
MCIArchitectureRuleTest class >> resetModel [

	model := nil
]

{ #category : 'accessing - methods' }
MCIArchitectureRuleTest >> methodNamed: aString [

	^ self model allModelMethods detect: [ :method | method name = aString ]
]

{ #category : 'accessing - methods' }
MCIArchitectureRuleTest >> model [

	^ self class model
]

{ #category : 'accessing - methods' }
MCIArchitectureRuleTest >> ruleWith: sentences [

	^ MCIArchitectureRule new
		  thresholds: {
				  (#modules -> {
						   (#ui -> '.*\.ui\..*').
						   (#domain -> '.*\.domain\..*').
						   (#infra -> '.*\.infra\..*') } asDictionary).
				  (#constraints -> sentences) } asDictionary;
		  yourself
]

{ #category : 'accessing - methods' }
MCIArchitectureRuleTest >> testKeyAndSeverity [

	self assert: MCIArchitectureRule key equals: #architecture.
	self assert: MCIArchitectureRule new severity equals: FamixCBErrorSeverity
]

{ #category : 'accessing - methods' }
MCIArchitectureRuleTest >> testModulesOn [

	| modules |
	modules := (self ruleWith: #(  )) modulesOn: self model.

	self assert: modules keys equals: #( #domain #ui #infra ).
	self assert: ((modules at: #ui) memberEntities includes: (self methodNamed: 'get')).
	self assert: ((modules at: #infra) memberEntities includes: (self methodNamed: 'load')).
	self assert: ((modules at: #domain) memberEntities includes: (self methodNamed: 'getId')).
	self deny: ((modules at: #ui) memberEntities includes: (self methodNamed: 'load'))
]

{ #category : 'accessing - methods' }
MCIArchitectureRuleTest >> violationsOf: aSentence [

	| violations |
	violations := MCIQualityRules runRules: { (self ruleWith: { aSentence }) } on: self model.
	^ violations values first
]

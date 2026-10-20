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

{ #category : 'tests' }
MCIArchitectureRuleTest >> testCannotViolated [

	| violations |
	
	violations := self violationsOf: 'ui cannot invoke infra'.
	
	self assert: violations size equals: 1.
	self assert: violations anyOne violatingEntity equals: (self methodNamed: 'get') outgoingInvocations anyOne
]

{ #category : 'tests' }
MCIArchitectureRuleTest >> testConstraintFromModules [

	| rule modules sentencesDict |
	rule := self ruleWith: #(  ).
	modules := rule modulesOn: self model.

	sentencesDict := {
		                 ('ui cannot depend infra' -> DCLCannotConstraint).
		                 ('ui must depend infra' -> DCLMustConstraint).
		                 ('ui canOnly depend infra' -> DCLCanOnlyConstraint).
		                 ('ui onlyCan depend infra' -> DCLOnlyCanConstraint) }.

	sentencesDict do: [ :each |
			| constraint |
			constraint := rule constraintFrom: each key modules: modules.
			self assert: constraint class equals: each value.
			self assert: constraint moduleA identicalTo: (modules at: #ui).
			self assert: constraint moduleB identicalTo: (modules at: #infra).
			self assert: constraint description equals: each key ]
]

{ #category : 'tests' }
MCIArchitectureRuleTest >> testConstraintFromModulesInvoke [

	| rule constraint |
	rule := self ruleWith: #(  ).
	constraint := rule constraintFrom: 'ui cannot invoke infra' modules: (rule modulesOn: self model).
	
	self assert: constraint associations isNotEmpty.
	self assert: (constraint associations allSatisfy: [ :assoc | assoc usesFamixTrait: FamixTInvocation ])
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

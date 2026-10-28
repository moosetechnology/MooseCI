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

{ #category : 'as yet unclassified' }
MCIArchitectureRuleTest >> ruleWithModules: aDictionary sentences: sentences [

	^ MCIArchitectureRule new
		  thresholds: {
				  (#modules -> aDictionary).
				  (#constraints -> sentences) } asDictionary;
		  yourself
]

{ #category : 'as yet unclassified' }
MCIArchitectureRuleTest >> testArchitectureModuleWithExcludeFromStonIsValid [

	| config |
	config := STON fromString: 'MooseCIConfig {
        #projectLanguage : #java,
        #rules : [
                #architecture : {
                        #modules : {
                                #ui : { #include : ''.*\\.ui\\..*'', #exclude : ''.*\\.ui\\.test\\..*'' },
                                #domain : ''.*\\.domain\\..*''
                        },
                        #constraints : [ ''ui cannot dependOn domain'' ]
                }
        ],
        #outputFormats : [ #json ],
        #outputPath : ''.moose-ci/report'',
        #visualizations : [ ],
        #isRemote : false
}'.

	self assert: config validationErrors isEmpty
]

{ #category : 'accessing - methods' }
MCIArchitectureRuleTest >> testCanOnlyRespected [

	self assert: (self violationsOf: 'infra canOnly invoke domain') isEmpty
]

{ #category : 'accessing - methods' }
MCIArchitectureRuleTest >> testCanOnlyViolated [

	self assert: (self violationsOf: 'ui canOnly invoke domain') size equals: 1
]

{ #category : 'accessing - methods' }
MCIArchitectureRuleTest >> testCannotDepend [

	  self assert: (self violationsOf: 'domain cannot dependOn infra') isNotEmpty
]

{ #category : 'accessing - methods' }
MCIArchitectureRuleTest >> testCannotRespected [

	self assert: (self violationsOf: 'ui cannot invoke domain') isEmpty.
	self assert: (self violationsOf: 'domain cannot invoke infra') isEmpty
]

{ #category : 'tests' }
MCIArchitectureRuleTest >> testCannotViolated [

	| violations |
	
	violations := self violationsOf: 'ui cannot invoke infra'.
	
	self assert: violations size equals: 1.
	self assert: violations anyOne violatingEntity equals: (self methodNamed: 'get') outgoingInvocations anyOne
]

{ #category : 'accessing - methods' }
MCIArchitectureRuleTest >> testCannotViolatedFromInfra [

	 self assert: (self violationsOf: 'infra cannot invoke domain') size equals: 1
]

{ #category : 'accessing - methods' }
MCIArchitectureRuleTest >> testConditionsOnOnePerSentence [

	| conditions |
	
	conditions := (self ruleWith: #( 'ui cannot invoke infra' 'domain cannot invoke ui' )) conditionsOn: self model.

	self assert: conditions size equals: 2.
	self assert: (conditions collect: #name) asArray equals: #( 'ui cannot invoke infra' 'domain cannot invoke ui' ).
	self assert: (conditions allSatisfy: [ :condition | condition severity = FamixCBErrorSeverity ])
]

{ #category : 'tests' }
MCIArchitectureRuleTest >> testConstraintFromModules [

	| rule modules sentencesDict |
	rule := self ruleWith: #(  ).
	modules := rule modulesOn: self model.

	sentencesDict := {
		                 ('ui cannot dependOn infra' -> DCLCannotConstraint).
		                 ('ui must dependOn infra' -> DCLMustConstraint).
		                 ('ui canOnly dependOn infra' -> DCLCanOnlyConstraint).
		                 ('ui onlyCan dependOn infra' -> DCLOnlyCanConstraint) }.

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

{ #category : 'as yet unclassified' }
MCIArchitectureRuleTest >> testExcludeRemovesViolation [

	| rule constraint |
	
	rule := self
		        ruleWithModules: {
				        (#ui -> {
					         (#include -> '.*\.ui\..*').
					         (#exclude -> '.*\.ui\.Controller\.get.*') } asDictionary).
				        (#domain -> '.*\.domain\..*').
				        (#infra -> '.*\.infra\..*') } asDictionary
		        sentences: #( 'ui canOnly invoke domain' ).
	constraint := (rule conditionsOn: self model) first.

	self assert: constraint check isEmpty
]

{ #category : 'accessing - methods' }
MCIArchitectureRuleTest >> testExistingRulesStillGiveOneCondition [
	"Guard for the MCIAbstractQualityRule >> #conditionsOn: "

	self assert: (MCITooManyParametersRule new conditionsOn: self model) size equals: 1
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

	self assert: modules keys asSet equals: #( #domain #ui #infra ) asSet.
	self assert: ((modules at: #ui) memberEntities includes: (self methodNamed: 'get')).
	self assert: ((modules at: #infra) memberEntities includes: (self methodNamed: 'load')).
	self assert: ((modules at: #domain) memberEntities includes: (self methodNamed: 'getId')).
	self deny: ((modules at: #ui) memberEntities includes: (self methodNamed: 'load'))
]

{ #category : 'as yet unclassified' }
MCIArchitectureRuleTest >> testModulesOnWithExclude [

	| rule ui |
	rule := self
		        ruleWithModules: { (#ui -> {
				         (#include -> '.*\.ui\..*').
				         (#exclude -> '.*\.ui\.Controller\.get.*') } asDictionary) } asDictionary
		        sentences: #(  ).
	ui := (rule modulesOn: self model) at: #ui.

	self deny: (ui memberEntities includes: (self methodNamed: 'get')).
	self assert: (ui memberEntities anySatisfy: [ :e | e mooseName = 'example.ui.Controller' ])
]

{ #category : 'as yet unclassified' }
MCIArchitectureRuleTest >> testModulesOnWithoutExcludeSameAsString [

	| withDict withString |
	
	withDict := ((self ruleWithModules: { (#ui -> { (#include -> '.*\.ui\..*') } asDictionary) } asDictionary sentences: #(  )) modulesOn:
		             self model) at: #ui.
		
	withString := ((self ruleWith: #(  )) modulesOn: self model) at: #ui.

	self assert: withDict memberEntities asSet equals: withString memberEntities asSet
]

{ #category : 'accessing - methods' }
MCIArchitectureRuleTest >> testMooseNameSeparator [

	| controller get |
	controller := self model allModelClasses detect: [ :class | class name = 'Controller' ].
	get := self methodNamed: 'get'.

	self assert: controller mooseName equals: 'example.ui.Controller'.
	self assert: (get mooseName beginsWith: 'example.ui.Controller.').


	self assert: ('.*\.ui\..*' asRegex matches: controller mooseName).
	self deny: ('ui' asRegex matches: controller mooseName).
	self deny: ('.*\.domain\..*' asRegex matches: controller mooseName)
]

{ #category : 'accessing - methods' }
MCIArchitectureRuleTest >> testMustRespected [

	       self assert: (self violationsOf: 'ui must invoke infra') isEmpty
]

{ #category : 'accessing - methods' }
MCIArchitectureRuleTest >> testMustViolated [

	   self assert: (self violationsOf: 'ui must invoke domain') size equals: 1
]

{ #category : 'accessing - methods' }
MCIArchitectureRuleTest >> testOnlyCanRespected [
	"infra is only invoked from ui"

	self assert: (self violationsOf: 'ui onlyCan invoke infra') isEmpty
]

{ #category : 'accessing - methods' }
MCIArchitectureRuleTest >> testOnlyCanViolated [
	"infra is invoked from ui, which is not domain"

	self assert: (self violationsOf: 'domain onlyCan invoke infra') size equals: 1
]

{ #category : 'accessing - methods' }
MCIArchitectureRuleTest >> testQueryHandlerIsNotImplemented [

	self should: [ (self ruleWith: #(  )) queryHandler ] raise: ShouldNotImplement
]

{ #category : 'accessing - methods' }
MCIArchitectureRuleTest >> violationsOf: aSentence [

	| violations |
	violations := MCIQualityRules runRules: { (self ruleWith: { aSentence }) } on: self model.
	self assert: violations size equals: 1.
	
	^ violations values first
]

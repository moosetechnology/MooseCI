Class {
	#name : 'MCIArchitectureRule',
	#superclass : 'MCIAbstractQualityRule',
	#category : 'MooseCI-QualityRules',
	#package : 'MooseCI-QualityRules'
}

{ #category : 'accessing' }
MCIArchitectureRule class >> defaultSeverity [

	^ FamixCBErrorSeverity
]

{ #category : 'accessing' }
MCIArchitectureRule class >> defaultThresholds [

	^ {
		  (#modules -> Dictionary new).
		  (#constraints -> #(  )) } asDictionary
]

{ #category : 'accessing' }
MCIArchitectureRule class >> dependencies [

	^ #( depend invoke access reference inherit )
]

{ #category : 'accessing' }
MCIArchitectureRule class >> description [ 

	^ 'Check dependencies between modules against architecture constraints'
]

{ #category : 'accessing' }
MCIArchitectureRule class >> key [

	^ #architecture
]

{ #category : 'accessing' }
MCIArchitectureRule class >> ruleName [

	^ 'Dependency Constraint'
]

{ #category : 'accessing' }
MCIArchitectureRule class >> verbs [

	^ #( cannot must canOnly onlyCan )
]

{ #category : 'accessing' }
MCIArchitectureRule >> conditionsOn: aMooseModel [

	| modules |
	modules := self modulesOn: aMooseModel.
	^ (self thresholdAt: #constraints) collect: [ :sentence |
			  | cbCondition |
			  cbCondition := (self constraintFrom: sentence modules: modules) asCBCondition.
			  cbCondition severity: self class defaultSeverity.
			  ^ cbCondition ]
]

{ #category : 'accessing' }
MCIArchitectureRule >> constraintFrom: aSentence modules: modules [
	"aSentence is '<module> <verb> <dependency> <module>"

	| words constraint |
	words := aSentence substrings.
	
	"<module> <verb>"
	constraint := (modules at: words first asSymbol) perform: words second asSymbol.
	
	"... <dependency> <module>"
	constraint perform: (words third, ':') asSymbol with: (modules at: words fourth asSymbol).
	
	constraint description: aSentence.
	
	^ constraint 
]

{ #category : 'accessing' }
MCIArchitectureRule >> contextFilterBlock [

	^ [ :entities | entities ]
]

{ #category : 'accessing' }
MCIArchitectureRule >> modulesOn: aMooseModel [

	| modules |
	modules := Dictionary new.
	(self thresholdAt: #modules) keysAndValuesDo: [ :name :regex |
			modules at: name asSymbol put: (DCLModuleOnMooseName new
					 name: name;
					 description: regex;
					 model: aMooseModel;
					 yourself) ].
	^ modules
]

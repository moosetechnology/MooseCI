"
I am the abstract base of the quality rules of MooseCI.

A rule detects, in a Moose model, the entities that violate a quality constraint.

New rules (Subclasses) must implement:
- `MCIAbstractQualityRule class >> #key` ............... unique identifier, e.g. `#longClass`
- `MCIAbstractQualityRule class >> #defaultThreshold` .. threshold used when none is set
- `MCIAbstractQualityRule >> #contextFilterBlock` ...... block restricting the analyzed entities. 
- `MCIAbstractQualityRule >> #queryHandler` ............ block deciding what counts as a violation 

and may override `MCIAbstractQualityRule class >> #ruleName` and `MCIAbstractQualityRule class >> #defaultSeverity`.

I expose `MCIAbstractQualityRule>>#context` (a FamixCBContext) and `MCIAbstractQualityRule>>#condition` (a FamixCBCondition). I run headlesslythrough FamixCBRunner, e.g.:
```
runner := FamixCBRunner new.
runner addRule: MiLongClassRule new.
violations := runner runOn: myModel
```
"
Class {
	#name : 'MCIAbstractQualityRule',
	#superclass : 'Object',
	#instVars : [
		'threshold',
		'severity'
	],
	#category : 'MooseCI-QualityRules',
	#package : 'MooseCI-QualityRules'
}

{ #category : 'accessing' }
MCIAbstractQualityRule class >> defaultSeverity [

	^ FamixCBWarningSeverity
]

{ #category : 'accessing' }
MCIAbstractQualityRule class >> defaultThreshold [ 

	^ self subclassResponsibility
]

{ #category : 'accessing' }
MCIAbstractQualityRule class >> description [

	^ self ruleName 
]

{ #category : 'accessing' }
MCIAbstractQualityRule class >> key [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
MCIAbstractQualityRule class >> ruleName [

	^ self key asString
]

{ #category : 'accessing' }
MCIAbstractQualityRule >> condition [

	^ (FamixCBCondition named: self name on: self queryHandler)
		  severity: self severity;
		  yourself
]

{ #category : 'accessing' }
MCIAbstractQualityRule >> context [

	^ FamixCBContext new
		  name: self name;
		  contextFilter: self contextFilterBlock;
		  yourself
]

{ #category : 'accessing' }
MCIAbstractQualityRule >> contextFilterBlock [

	^ self subclassResponsibility
]

{ #category : 'initialization' }
MCIAbstractQualityRule >> initialize [

	super initialize.
	threshold := self class defaultThreshold.
	severity := self class defaultSeverity
]

{ #category : 'initialization' }
MCIAbstractQualityRule >> key [

	^ self class key 
]

{ #category : 'initialization' }
MCIAbstractQualityRule >> name [

	^ self class ruleName 
]

{ #category : 'accessing' }
MCIAbstractQualityRule >> queryHandler [

	^ self subclassResponsibility 
]

{ #category : 'accessing' }
MCIAbstractQualityRule >> severity [

	^ severity
]

{ #category : 'accessing' }
MCIAbstractQualityRule >> severity: aFamixCBSeverityClass [

	severity := aFamixCBSeverityClass
]

{ #category : 'accessing' }
MCIAbstractQualityRule >> threshold [

	^ threshold
]

{ #category : 'accessing' }
MCIAbstractQualityRule >> threshold: aNumber [

	threshold := aNumber
]

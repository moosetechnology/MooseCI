Class {
	#name : 'BaselineOfMooseCI',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfMooseCI',
	#package : 'BaselineOfMooseCI'
}

{ #category : 'baselines' }
BaselineOfMooseCI >> baseline: spec [

	<baseline>
	spec for: #common do: [
		self defineDependencies: spec.
		self definePackages: spec.
		self defineGroups: spec. ]
]

{ #category : 'baselines' }
BaselineOfMooseCI >> defineDependencies: spec [

	spec baseline: 'MoosePy' with: [ spec repository: 'github://moosetechnology/MoosePy:master/src' ]
]

{ #category : 'baselines' }
BaselineOfMooseCI >> defineGroups: spec [ 

	spec
		group: 'default'
		with: #( 'MooseCI-Core' 'MooseCI-CLI' 'MooseCI-Tests' )

]

{ #category : 'baselines' }
BaselineOfMooseCI >> definePackages: spec [ 

	spec
		package: 'MooseCI-Core'
		with: [ spec requires: #( 'MoosePy' ) ];
		package: 'MooseCI-CLI';
		package: 'MooseCI-Tests';
		package: 'MooseCI-TreeSitter-Libs'

]

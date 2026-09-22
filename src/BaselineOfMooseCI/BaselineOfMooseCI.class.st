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

	spec
		baseline: 'MoosePy' with: [ spec repository: 'github://moosetechnology/MoosePy:master/src' ];
		baseline: 'TreeSitter' with: [
				spec
					repository: 'github://Evref-BL/Pharo-Tree-Sitter:main/src';
					loads: #( 'python' ) ]
]

{ #category : 'baselines' }
BaselineOfMooseCI >> defineGroups: spec [ 

	spec
		group: 'default'
		with: #( 'MooseCI-Core' 'MooseCI-CLI' 'MooseCI-Tests' 'MooseCI-QualityRules' 'MooseCI-QualityRules-Tests' 'MooseCI-Report' 'MooseCI-Metrics' 'MooseCI-Metrics-Tests' 'MooseCI-QualityRules-Java' 'MooseCI-QualityRules-Python' 'MooseCI-Metrics-Java' 'MooseCI-Metrics-Python' )

]

{ #category : 'baselines' }
BaselineOfMooseCI >> definePackages: spec [

	spec
		package: 'MooseCI-Core' with: [ spec requires: #( 'MoosePy' 'TreeSitter') ];
		package: 'MooseCI-CLI';
		package: 'MooseCI-Tests';
		package: 'MooseCI-QualityRules';
		package: 'MooseCI-QualityRules-Java';
		package: 'MooseCI-Metrics-Java';
		package: 'MooseCI-QualityRules-Python';
		package: 'MooseCI-Metrics-Python';
		package: 'MooseCI-QualityRules-Tests';
		package: 'MooseCI-Metrics';
		package: 'MooseCI-Metrics-Tests';
		package: 'MooseCI-Report'.
]

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
					loads: #( 'python' ) ];
		baseline: 'GitBridge' with: [
				spec
					repository: 'github://jecisc/GitBridge:master/src';
					loads: #( 'Minimal' ) ]
]

{ #category : 'baselines' }
BaselineOfMooseCI >> defineGroups: spec [ 

	spec
		group: 'default'
		with: #( 'MooseCI-Core' 'MooseCI-CLI' 'MooseCI-Tests' 'MooseCI-QualityRules' 'MooseCI-QualityRules-Tests' 'MooseCI-Report' 'MooseCI-Metrics' 'MooseCI-Metrics-Tests' 'MooseCI-QualityRules-Java' 'MooseCI-Metrics-Java' );
		group: 'python'
		with: #( 'MooseCI-Core-Python' 'MooseCI-QualityRules-Python' 'MooseCI-Metrics-Python' 'MooseCI-Python-Tests');
		group: 'all'
		with: #( 'default' 'python' )

]

{ #category : 'baselines' }
BaselineOfMooseCI >> definePackages: spec [

	spec
		package: 'MooseCI-Core' with: [ spec requires: #( 'GitBridge' ) ];
		package: 'MooseCI-CLI';
		package: 'MooseCI-Tests';
		package: 'MooseCI-QualityRules';
		package: 'MooseCI-QualityRules-Tests';
		package: 'MooseCI-Metrics';
		package: 'MooseCI-Metrics-Tests';
		package: 'MooseCI-Report';
		package: 'MooseCI-QualityRules-Java' with: [ spec requires: #( 'MooseCI-QualityRules' ) ];
		package: 'MooseCI-Metrics-Java' with: [ spec requires: #( 'MooseCI-Metrics' ) ];
		package: 'MooseCI-Core-Python' with: [ spec requires: #( 'MooseCI-Core' 'MoosePy' 'TreeSitter' ) ];
		package: 'MooseCI-QualityRules-Python' with: [ spec requires: #( 'MooseCI-QualityRules' 'MoosePy' ) ];
		package: 'MooseCI-Metrics-Python' with: [ spec requires: #( 'MooseCI-Metrics' 'MoosePy' ) ];
		package: 'MooseCI-Python-Tests' with: [ spec requires: #('MooseCI-Core-Python') ]
]

Class {
	#name : 'MCIMetricsTest',
	#superclass : 'TestCase',
	#category : 'MooseCI-Metrics-Tests',
	#package : 'MooseCI-Metrics-Tests'
}

{ #category : 'tests' }
MCIMetricsTest >> testAllMetrics [

	| metrics |
	metrics := MCIMetrics allMetrics.

	self assert: metrics size equals: MCIAbstractMetric subclasses size.
	self assert: (metrics allSatisfy: [ :metric | metric superclass = MCIAbstractMetric ])
]

{ #category : 'tests' }
MCIMetricsTest >> testComputeMetricsOn [

	| model metrics |
	model := FamixPythonModel new.
	FamixPythonModule new
		name: 'main';
		mooseModel: model.
	FamixPythonPackage new
		name: 'pkg';
		mooseModel: model.
	FamixPythonClass new
		name: 'Foo';
		mooseModel: model.

	metrics := MCIMetrics computeMetrics: #( #files #packages #classes ) on: model.

	self assert: (metrics at: #files) equals: 1.
	self assert: (metrics at: #packages) equals: 1.
	self assert: (metrics at: #classes) equals: 1
]

{ #category : 'tests' }
MCIMetricsTest >> testDefaultApplicableLanguagesIsAll [

	self assert: MCIAbstractMetric applicableLanguages equals: #all
]

{ #category : 'tests' }
MCIMetricsTest >> testDefaultMetrics [

	self assert: MCIMetrics defaultMetrics equals: #( #files #loc #packages #classes )
]

{ #category : 'tests' }
MCIMetricsTest >> testJavaMetrics [

	self assert: MCIMetrics javaMetrics equals: #( #files #loc #packages #classes )
]

{ #category : 'tests' }
MCIMetricsTest >> testMetricAt [

	| metric |
	metric := MCIMetrics metricAt: #loc.

	self assert: metric equals: MCILinesOfCodeMetric
]

{ #category : 'tests' }
MCIMetricsTest >> testMetricAtNotFound [

	self assertBlock: [ MCIMetrics metricAt: #a_non_existing_metric_key ] raises: MCIMetricNotFoundError
]

{ #category : 'tests' }
MCIMetricsTest >> testPythonMetrics [

	self assert: MCIMetrics pythonMetrics equals: #( #files #loc #packages #classes )
]

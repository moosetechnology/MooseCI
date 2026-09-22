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
	
	model := FamixJavaModel new.
	model newPackageNamed: 'aPackage'.
	model newClassNamed: 'AClass'.

	metrics := MCIMetrics computeMetrics: #( #packages #classes ) on: model.

	self assert: (metrics at: #packages) equals: 1.
	self assert: (metrics at: #classes) equals: 1
]

{ #category : 'tests' }
MCIMetricsTest >> testDefaultApplicableLanguagesIsAll [

	self assert: MCIAbstractMetric applicableLanguages equals: #all
]

{ #category : 'tests' }
MCIMetricsTest >> testDefaultMetrics [

	self assert: MCIMetrics defaultMetrics equals: #( #files #loc )
]

{ #category : 'tests' }
MCIMetricsTest >> testMetricAt [

	| metric |
	metric := MCIMetrics metricAt: #classes.

	self assert: metric equals: MCINumberOfClassesMetric 
]

{ #category : 'tests' }
MCIMetricsTest >> testMetricAtNotFound [

	self assertBlock: [ MCIMetrics metricAt: #a_non_existing_metric_key ] raises: MCIMetricNotFoundError
]

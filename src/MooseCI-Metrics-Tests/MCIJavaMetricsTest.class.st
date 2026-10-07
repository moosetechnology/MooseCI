Class {
	#name : 'MCIJavaMetricsTest',
	#superclass : 'TestCase',
	#category : 'MooseCI-Metrics-Tests',
	#package : 'MooseCI-Metrics-Tests'
}

{ #category : 'tests' }
MCIJavaMetricsTest >> testJavaMetrics [

	self assert: MCIMetrics javaMetrics equals: #( #packages #classes )
]

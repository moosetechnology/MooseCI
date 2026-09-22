Class {
	#name : 'MCIJavaMetricsTest',
	#superclass : 'TestCase',
	#category : 'MooseCI-Metrics-Java',
	#package : 'MooseCI-Metrics-Java'
}

{ #category : 'tests' }
MCIJavaMetricsTest >> testJavaMetrics [

	self assert: MCIMetrics javaMetrics equals: #( #packages #classes )
]

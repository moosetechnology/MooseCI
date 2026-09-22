Class {
	#name : 'MCIPyMetricsTest',
	#superclass : 'TestCase',
	#category : 'MooseCI-Metrics-Python',
	#package : 'MooseCI-Metrics-Python'
}

{ #category : 'tests' }
MCIPyMetricsTest >> testPythonMetrics [

	self assert: MCIMetrics pythonMetrics equals: #( #files #loc #classes )
]

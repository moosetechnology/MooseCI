Class {
	#name : 'MCIPyMetricsTest',
	#superclass : 'TestCase',
	#category : 'MooseCI-Python-Tests',
	#package : 'MooseCI-Python-Tests'
}

{ #category : 'tests' }
MCIPyMetricsTest >> testPythonMetrics [

	self assert: MCIMetrics pythonMetrics equals: #( #files #loc #classes )
]

Class {
	#name : 'MooseCIPyConfigTest',
	#superclass : 'TestCase',
	#category : 'MooseCI-Python-Tests',
	#package : 'MooseCI-Python-Tests'
}

{ #category : 'tests' }
MooseCIPyConfigTest >> testConfigForPythonIsValid [

	| config |
	config := MooseCIConfig for: #python.
	config validate.
	self assert: config validationErrors isEmpty
]

{ #category : 'tests' }
MooseCIPyConfigTest >> testForReturnsPythonConfig [

	| config |
	config := MooseCIConfig for: #python.

	self assert: config projectLanguage equals: #python.
	self assert: config rules equals: MCIQualityRules pythonRules
]

{ #category : 'tests' }
MooseCIPyConfigTest >> testPythonDefaultConfig [

	| config |
	config := MooseCIConfig python.

	self assert: config projectLanguage equals: #python.
	self assert: config metrics equals: MCIMetrics pythonMetrics.
	self assert: config outputPath equals: '.moose-ci/report'.
	self deny: config isRemote.
]

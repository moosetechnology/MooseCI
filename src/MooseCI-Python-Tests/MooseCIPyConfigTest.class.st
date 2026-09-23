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

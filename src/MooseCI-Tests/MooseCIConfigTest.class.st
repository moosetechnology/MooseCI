Class {
	#name : 'MooseCIConfigTest',
	#superclass : 'TestCase',
	#category : 'MooseCI-Tests',
	#package : 'MooseCI-Tests'
}

{ #category : 'tests' }
MooseCIConfigTest >> testToSton [ 
	|stonString config|
	config := MooseCIConfig default.
	stonString := config toSton.
	
self assert: (stonString includesSubstring: 'MooseCIConfig').
self assert: (stonString includesSubstring: '#metrics').
self assert: (stonString includesSubstring: '#rules').
self assert: (stonString includesSubstring: '#ruleThresholds').
]

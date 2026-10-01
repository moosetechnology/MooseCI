Class {
	#name : 'MooseCIConfigForTest',
	#superclass : 'MooseCIConfig',
	#category : 'MooseCI-Tests',
	#package : 'MooseCI-Tests'
}

{ #category : 'accessing' }
MooseCIConfigForTest class >> java [

	^ #javaConfig
]

{ #category : 'accessing' }
MooseCIConfigForTest class >> python [

	^ self error: 'The python config must not be evaluated'
]

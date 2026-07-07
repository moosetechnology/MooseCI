Class {
	#name : 'MooseCIBridge',
	#superclass : 'GitBridge',
	#category : 'MooseCI-Core',
	#package : 'MooseCI-Core'
}

{ #category : 'class initialization' }
MooseCIBridge class >> initialize [
	SessionManager default registerSystemClassNamed: self name
]

{ #category : 'class initialization' }
MooseCIBridge class >> mockProjectTests [

	^ self root / 'ressources/mockProjectTests'
]

{ #category : 'class initialization' }
MooseCIBridge class >> rules [

	^ self root / 'ressources/rules_1.ston'
]

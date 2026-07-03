Class {
	#name : 'MooseCIRunner',
	#superclass : 'Object',
	#instVars : [
		'projectFilePath',
		'mooseCICore'
	],
	#classInstVars : [
		'mooseCI'
	],
	#category : 'MooseCI-CLI',
	#package : 'MooseCI-CLI'
}

{ #category : 'as yet unclassified' }
MooseCIRunner class >> analyze: aProjectPath [
	
	(self new projectFilePath: aProjectPath ) run.
]

{ #category : 'as yet unclassified' }
MooseCIRunner class >> printOn: aStream [
	aStream nextPutAll: 'A MooseCI CLI instance'
]

{ #category : 'running' }
MooseCIRunner >> loadProject [

	'Importing ', projectFilePath, '...' traceCr.
	mooseCICore loadProject: projectFilePath.
	'Famix model created.' traceCr.
]

{ #category : 'accessing' }
MooseCIRunner >> projectFilePath: anObject [

	projectFilePath := anObject
]

{ #category : 'running' }
MooseCIRunner >> run [
	mooseCICore := MooseCICore new.
	self loadProject.
	self runAnalysis.
	self writeOutputs.
]

{ #category : 'running' }
MooseCIRunner >> runAnalysis [
	mooseCICore runAnalysis.
]

{ #category : 'running' }
MooseCIRunner >> writeOutputs [
	
	| size |
	
	size := mooseCICore sizeReport. 
	'Size' traceCr.
	('    ', size files asString , ' files | ', size loc asString, ' LOC | ', size packages asString, ' packages | ', size classes asString, ' classes') traceCr
]

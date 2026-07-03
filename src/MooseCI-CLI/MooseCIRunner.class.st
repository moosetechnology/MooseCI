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
MooseCIRunner >> writeCriticsOutput [

	| violations |
	violations := mooseCICore violations.
	
	'Quality' traceCr.
	
	violations keysDo: [ :condition | ('    ' , condition name , ': ' , (violations at: condition) size asString) traceCr ]
]

{ #category : 'running' }
MooseCIRunner >> writeOutputs [
	
	self writeSizeOutputs.
	self writeCriticsOutput.
]

{ #category : 'running' }
MooseCIRunner >> writeSizeOutputs [
	
	| size |
	
	size := mooseCICore sizeReport. 
	'Size' traceCr.
	('    ', size files asString , ' files | ', size loc asString, ' LOC | ', size packages asString, ' packages | ', size classes asString, ' classes') traceCr
]

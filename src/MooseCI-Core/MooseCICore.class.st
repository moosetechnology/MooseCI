Class {
	#name : 'MooseCICore',
	#superclass : 'Object',
	#instVars : [
		'model',
		'sizeReport'
	],
	#category : 'MooseCI-Core',
	#package : 'MooseCI-Core'
}

{ #category : 'initialization' }
MooseCICore >> initialize [ 
	sizeReport := MooseCISizeReport new
]

{ #category : 'loading' }
MooseCICore >> loadProject: aProjectFilePath [
	model := FamixPythonImporter import: aProjectFilePath asFileReference.
	
]

{ #category : 'loading' }
MooseCICore >> runAnalysis [

	sizeReport files: model allModules size.
	sizeReport loc: (model allModules collect: [ :eachModule | eachModule sourceAnchor lineCount ]) sum.
	sizeReport packages: model allPackages size. 
	sizeReport classes: model allClasses size.
]

{ #category : 'accessing' }
MooseCICore >> sizeReport [

	^ sizeReport
]

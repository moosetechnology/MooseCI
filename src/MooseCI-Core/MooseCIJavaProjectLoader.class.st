Class {
	#name : 'MooseCIJavaProjectLoader',
	#superclass : 'MooseCIProjectLoader',
	#category : 'MooseCI-Core',
	#package : 'MooseCI-Core'
}

{ #category : 'as yet unclassified' }
MooseCIJavaProjectLoader class >> dockerAvailable [

	(LibC runCommand: 'docker --version') = 0 ifTrue: [ ^ true ].
	
	^ false
]

{ #category : 'testing' }
MooseCIJavaProjectLoader class >> hasVerveinejJar [

	| jarFileReference |
	jarFileReference := '/opt/verveinej/VerveineJ.jar' asFileReference.
	^ jarFileReference exists
]

{ #category : 'as yet unclassified' }
MooseCIJavaProjectLoader class >> languageNameSymbol [

	^ #java
]

{ #category : 'as yet unclassified' }
MooseCIJavaProjectLoader class >> load: aProjectFilePath [

	self dockerAvailable ifTrue: [
			| command importer status model |
			command := self verveinejDockerCommandFor: aProjectFilePath asFileReference version: 'latest' outputFileName: 'model.json'.
			status := LibC runCommand: command.

			status = 0 ifFalse: [ Error signal: 'Failed to run command: ' , command ].

			model := FamixJavaModel new
				         rootFolder: aProjectFilePath;
				         yourself.
			importer := FamixJSONFileImporter new
				            model: model;
				            inputFile: aProjectFilePath asFileReference / 'model.json';
				            yourself.
			importer run.
			^ model ].

	self hasVerveinejJar ifTrue: [ ^ self ].

	"neither docker or jar available"

	Error signal: 'VerveineJ not found. Install the VerveineJ jar or the docker version'
]

{ #category : 'as yet unclassified' }
MooseCIJavaProjectLoader class >> strategyWithJarAvailable: isJarAvailable dockerAvailable: isDockerAvailable [ 
	
	self flag: #TODO
]

{ #category : 'as yet unclassified' }
MooseCIJavaProjectLoader class >> verveinejDockerCommandFor: aFileReference version: version outputFileName: fileName [

	^ String streamContents: [ :s |
		  s << 'docker run -v ''' << aFileReference fullName << ''':/src ghcr.io/evref-bl/verveinej:' << version << ' -format json -o ' << fileName ]
]

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

	| command status model modelFilename strategy|
	
	modelFilename := 'model.json'.
	
	strategy := self strategyWithJarAvailable: self hasVerveinejJar dockerAvailable: self dockerAvailable.

	command := strategy = #jar
		           ifTrue: [
				           self
					           verveinejJarCommandFor: aProjectFilePath asFileReference
					           jar: '/opt/verveinej/VerveineJ.jar' asFileReference
					           xmx: '-Xmx2g'
					           outputFileName: modelFilename ]
		           ifFalse: [ self verveinejDockerCommandFor: aProjectFilePath asFileReference version: 'latest' outputFileName: modelFilename ].



	status := LibC runCommand: command.

	status = 0 ifFalse: [ Error signal: 'Failed to run command: ' , command ].

	model := FamixJavaModel new
		         rootFolder: aProjectFilePath;
		         yourself.
		
	FamixJSONFileImporter new
		model: model;
		inputFile: aProjectFilePath asFileReference / modelFilename;
		run.


	^ model
]

{ #category : 'as yet unclassified' }
MooseCIJavaProjectLoader class >> strategyWithJarAvailable: isJarAvailable dockerAvailable: isDockerAvailable [

	isJarAvailable ifTrue: [ ^ #jar ].
	isDockerAvailable ifTrue: [ ^ #docker ].
	
	Error signal: 'VerveineJ not found. Install the VerveineJ jar or the docker version'
]

{ #category : 'as yet unclassified' }
MooseCIJavaProjectLoader class >> verveinejDockerCommandFor: aFileReference version: version outputFileName: fileName [

	^ String streamContents: [ :s |
		  s << 'docker run -v ''' << aFileReference fullName << ''':/src ghcr.io/evref-bl/verveinej:' << version << ' -format json -o ' << fileName ]
]

{ #category : 'as yet unclassified' }
MooseCIJavaProjectLoader class >> verveinejJarCommandFor: projectPath jar: jarPath xmx: xmx outputFileName: fileName [ 
	
	^ String streamContents: [ :s | 
		s << 'java ' << xmx << ' -jar ' << jarPath fullName << ' -format json -alllocals -anchor assoc -o ' << fileName << ' ' << projectPath fullName 
		 ].
]

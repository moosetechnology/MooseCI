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

	self dockerAvailable ifTrue: [ ^ self ].

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

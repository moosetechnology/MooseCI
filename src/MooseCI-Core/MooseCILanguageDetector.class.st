Class {
	#name : 'MooseCILanguageDetector',
	#superclass : 'Object',
	#category : 'MooseCI-Core',
	#package : 'MooseCI-Core'
}

{ #category : 'as yet unclassified' }
MooseCILanguageDetector class >> countFile: aFileReference into: aMooseCILanguageDetectionResult [

	| ext language |
	ext := aFileReference extension asLowercase.
	ext isEmpty ifTrue: [ ^ self ].

	language := self extensionMap at: ext ifAbsent: [ ^ self ].
	aMooseCILanguageDetectionResult incrementCountAt: language
]

{ #category : 'as yet unclassified' }
MooseCILanguageDetector class >> countFilesIn: aDirectory into: aMooseCILanguageDetectionResult [ 
	aDirectory children do: [ :child |
        (child isDirectory)
            ifTrue: [
                (self ignoredDirectoryNames includes: child basename)
                    ifFalse: [ self countFilesIn: child into: aMooseCILanguageDetectionResult ] ]
            ifFalse: [
                self
                    countFile: child
                    into: aMooseCILanguageDetectionResult ] ]
]

{ #category : 'enumerating' }
MooseCILanguageDetector class >> detect: aDirectoryOrFileReference [

	| root counter |
	root := aDirectoryOrFileReference asFileReference.

	(root exists and: [ root isDirectory ]) ifFalse: [ ^ Error signal: 'Not a directory: ' , root fullName ].

	
	counter := MooseCILanguageDetectionResult new.
	self countFilesIn: root into: counter.

	^ counter
]

{ #category : 'as yet unclassified' }
MooseCILanguageDetector class >> extensionMap [

	| extensionMap |
	extensionMap := Dictionary new.
	extensionMap
		at: 'java' put: #java;
		at: 'py' put: #python;
		at: 'ts' put: #typescript;
		at: 'tsx' put: #typescript;
		at: 'c' put: #c;
		at: 'h' put: #c.

	^ extensionMap
]

{ #category : 'as yet unclassified' }
MooseCILanguageDetector class >> ignoredDirectoryNames [

	^ #( '.git' '.hg' '.svn' 'node_modules' 'venv' '.venv' '__pycache__' 'target' 'build' 'dist' 'out' '.idea' '.vscode' )
]

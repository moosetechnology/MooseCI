Class {
	#name : 'MCIFamixJavaFoldersImporter',
	#superclass : 'FamixJavaFoldersImporter',
	#category : 'MooseCI-Core',
	#package : 'MooseCI-Core'
}

{ #category : 'actions' }
MCIFamixJavaFoldersImporter >> generateJsonOfProjects [

	folders
		do: [ :folder |
				| command status |
				command := 'java -jar {1} -o {2}  {3} -format json -alllocals {4} {5}' format: {
							   self verveineJJar pathString asComment.
							   (self jsonForFolder: folder).
							   (self jdkVersion
								    ifNil: [ '' ]
								    ifNotNil: [ '-jdkMode -' , jdkVersion ]).
							   (self autoClasspath
								    ifNil: [ '' ]
								    ifNotNil: [ '-autocp ' , autoClasspath pathString asComment ]).
							   folder pathString asComment }.

				status := LibC runCommand: command.
				status = 0 ifFalse: [ Error signal: 'VerveineJ command failed: ' , command ] ]
		displayingProgress: [ :folder | folder pathString ]
]

{ #category : 'actions' }
MCIFamixJavaFoldersImporter >> jsonForFolder: folder [

	^ (folder asFileReference / (folder asFileReference basename , '.json')) fullName
]

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
				LibC runCommand: ('cd {1} && java -jar {2} -o {3}  {4} -format json -alllocals {5} {6}' format: {
							FileLocator localDirectory fullName.
							 self verveineJJar pathString asComment.
							 (self jsonForFolder: folder).
							 (self jdkVersion
								  ifNil: [ '' ]
								  ifNotNil: [ '-jdkMode -' , jdkVersion ]).
							(self autoClasspath 
								  ifNil: [ '' ]
								  ifNotNil: [ '-autocp ' , autoClasspath pathString asComment ]).
							 folder pathString asComment }) ]
		displayingProgress: [ :folder | folder pathString ]
]

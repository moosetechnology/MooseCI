"
MooseCIJavaProjectLoaderTest is a test class for testing the behavior of MooseCIJavaProjectLoader.
"
Class {
	#name : 'MooseCIJavaProjectLoaderTest',
	#superclass : 'TestCase',
	#category : 'MooseCI-Tests',
	#package : 'MooseCI-Tests'
}

{ #category : 'helpers' }
MooseCIJavaProjectLoaderTest >> hasVerveinejOrDocker [

	^ MooseCIJavaProjectLoader hasVerveinejJar or: [ MooseCIJavaProjectLoader dockerAvailable ]
]

{ #category : 'tests' }
MooseCIJavaProjectLoaderTest >> testDockerCommand [

	| command |
	command := MooseCIJavaProjectLoader
		           verveinejDockerCommandFor: '/tmp/project' asFileReference
		           version: 'v5.0.0'
		           outputFileName: 'moose-ci-model.json'.

	self
		assert: command
		equals:
		'docker run -v ''/tmp/project'':/src ghcr.io/evref-bl/verveinej:v5.0.0 -format json -o moose-ci-model.json'
]

{ #category : 'tests' }
MooseCIJavaProjectLoaderTest >> testJarCommand [

	| command |
	command := MooseCIJavaProjectLoader
		           verveinejJarCommandFor: '/tmp/project' asFileReference
		           jar: '/opt/verveinej/VerveineJ.jar' asFileReference
		           xmx: '-Xmx2g'
		           outputFileName: 'model.json'.

	self
		assert: command
		equals:
		'java -Xmx2g -jar /opt/verveinej/VerveineJ.jar -format json -alllocals -anchor assoc -o model.json /tmp/project'
]

{ #category : 'tests' }
MooseCIJavaProjectLoaderTest >> testJavaLoaderIsSelectedForJava [

	self
		assert: (MooseCIProjectLoader forLanguage: #java)
		equals: MooseCIJavaProjectLoader
]

{ #category : 'tests' }
MooseCIJavaProjectLoaderTest >> testLanguageNameSymbol [

	self assert: MooseCIJavaProjectLoader languageNameSymbol equals: #java
]

{ #category : 'tests' }
MooseCIJavaProjectLoaderTest >> testLoadJavaProjectReturnsFamixJavaModel [

	| model projectPath |
	self hasVerveinejOrDocker ifFalse: [ self skip ].

	projectPath := MooseCIBridge mockProjectTests / 'java-only'.
	model := MooseCIJavaProjectLoader load: projectPath.

	self assert: (model isKindOf: FamixJavaModel).
	self assert: model isNotEmpty.
	self assert: (model allClasses anySatisfy: [ :c | c name = 'Main' ]).
	self assert: (model allClasses anySatisfy: [ :c | c name = 'DummyClass' ]).
	self assert: (model allClasses anySatisfy: [ :c | c name = 'NoDocstring' ]).
	self
		assert: model rootFolder asFileReference fullName
		equals: projectPath fullName
]

{ #category : 'tests' }
MooseCIJavaProjectLoaderTest >> testStrategyErrorsWhenNoToolAvailable [

	self
		should: [
			MooseCIJavaProjectLoader strategyWithJarAvailable: false dockerAvailable: false ]
		raise: Error
]

{ #category : 'tests' }
MooseCIJavaProjectLoaderTest >> testStrategyFallsBackToDocker [

	self
		assert:
		(MooseCIJavaProjectLoader strategyWithJarAvailable: false dockerAvailable: true)
		equals: #docker
]

{ #category : 'tests' }
MooseCIJavaProjectLoaderTest >> testStrategyPrefersLocalJar [

	self
		assert:
		(MooseCIJavaProjectLoader strategyWithJarAvailable: true dockerAvailable: false)
		equals: #jar
]

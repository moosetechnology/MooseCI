Class {
	#name : 'MCIReportWriterTest',
	#superclass : 'MCIReportTestCase',
	#category : 'MooseCI-Tests',
	#package : 'MooseCI-Tests'
}

{ #category : 'tests' }
MCIReportWriterTest >> testDefaultFileName [

	self assert: MCIJSONReportWriter defaultFileName equals: 'report.json'.
	self assert: MCIConsoleReportWriter defaultFileName isEmpty
]

{ #category : 'tests' }
MCIReportWriterTest >> testDefaultOutputFormats [

	self assert: MCIReportWriter defaultOutputFormats equals: { #json }
]

{ #category : 'tests' }
MCIReportWriterTest >> testFilenameInitializedFromClass [

	self assert: MCIJSONReportWriter new filename equals: 'report.json'.
	self assert: MCIConsoleReportWriter new filename isEmpty
]

{ #category : 'tests' }
MCIReportWriterTest >> testSubclassesImplementFormatProtocol [

	MCIReportWriter subclasses do: [ :writerClass |
		self assert: writerClass formatKey isNotNil.
		self assert: writerClass fileExtension isNotNil ]
]

{ #category : 'tests' }
MCIReportWriterTest >> testWriterAt [

	self assert: (MCIReportWriter writerAt: #json) equals: MCIJSONReportWriter.
	self assert: (MCIReportWriter writerAt: #console) equals: MCIConsoleReportWriter
]

{ #category : 'tests' }
MCIReportWriterTest >> testWriterAtNotFound [

	self assertBlock: [ MCIReportWriter writerAt: #html ] raises: MCIReportWriterNotFoundError
]

{ #category : 'tests' }
MCIReportWriterTest >> testWriteReportToFile [

	| writer file |
	writer := MCIJSONReportWriter new.
	file := FileLocator workingDirectory / 'moose-ci-test-report.json'.
	writer writeReport: self report toFile: file.

	self assert: file exists.
	self assert: (file contents includesSubstring: 'main.py')
]

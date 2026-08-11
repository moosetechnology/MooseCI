Class {
	#name : 'MCIReportWriter',
	#superclass : 'Object',
	#instVars : [
		'report',
		'filename'
	],
	#category : 'MooseCI-Report',
	#package : 'MooseCI-Report'
}

{ #category : 'accessing' }
MCIReportWriter class >> defaultFileName [

	^ self subclassResponsibility
]

{ #category : 'formatting' }
MCIReportWriter class >> formatKey [
	"json, csv, html, whatever from the config file"

	^ self subclassResponsibility
]

{ #category : 'accessing' }
MCIReportWriter class >> writerAt: aSymbol [

	self subclasses
		detect: [ :writerClass | writerClass key = aSymbol ]
		ifFound: [ :writerClass | writerClass ]
		ifNone: [ MCIReportWriterNotFoundError signal: 'Report Writer not found for: ' , aSymbol asString ]
]

{ #category : 'accessing' }
MCIReportWriter >> filename [

	^ filename
]

{ #category : 'accessing' }
MCIReportWriter >> filename: anObject [

	filename := anObject
]

{ #category : 'accessing' }
MCIReportWriter >> report [

	^ report
]

{ #category : 'accessing' }
MCIReportWriter >> report: anObject [

	report := anObject
]

{ #category : 'writing' }
MCIReportWriter >> writeOn: aStream [

	^ self subclassResponsibility
]

{ #category : 'writing' }
MCIReportWriter >> writeReport: aMCIAnalysisReport toFile: aFileReference [

	self report: aMCIAnalysisReport.
	aFileReference parent ensureDirectory.
	aFileReference writeStreamDo: [ :stream | self writeOn: stream ]
]

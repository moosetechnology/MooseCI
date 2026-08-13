"
I am a data model that aggregates metrics, violations, config
"
Class {
	#name : 'MCIAnalysisReport',
	#superclass : 'Object',
	#instVars : [
		'metrics',
		'violations',
		'config'
	],
	#category : 'MooseCI-Report',
	#package : 'MooseCI-Report'
}

{ #category : 'instance creation' }
MCIAnalysisReport class >> newFrom: aMCIConfig metrics: aMCIMetricsReport violations: aDictionnary [

	^ self new
		  config: aMCIConfig;
		  metrics: aMCIMetricsReport;
		  violations: aDictionnary;
		  yourself
]

{ #category : 'accessing' }
MCIAnalysisReport >> config [

	^ config
]

{ #category : 'accessing' }
MCIAnalysisReport >> config: anObject [

	config := anObject
]

{ #category : 'initialization' }
MCIAnalysisReport >> initialize [ 

	super initialize. 
]

{ #category : 'accessing' }
MCIAnalysisReport >> metrics [

	^ metrics
]

{ #category : 'accessing' }
MCIAnalysisReport >> metrics: anObject [

	metrics := anObject
]

{ #category : 'as yet unclassified' }
MCIAnalysisReport >> outputDirectory [

	^ FileLocator workingDirectory / self config outputPath
]

{ #category : 'accessing' }
MCIAnalysisReport >> violations [

	^ violations
]

{ #category : 'accessing' }
MCIAnalysisReport >> violations: anObject [

	violations := anObject
]

{ #category : 'writing' }
MCIAnalysisReport >> writeConsole [

	MCIConsoleReportWriter new
		report: self;
		writeOn: Stdio stdout
]

{ #category : 'writing' }
MCIAnalysisReport >> writeFiles [

	self config outputFormats do: [ :formatKey |
			| writer outputfile |
			writer := (MCIReportWriter writerAt: formatKey) new.
			outputfile := self outputDirectory / writer filename.
			writer writeReport: self toFile: outputfile ]
]

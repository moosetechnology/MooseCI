Class {
	#name : 'MCIConsoleReportWriter',
	#superclass : 'MCIReportWriter',
	#category : 'MooseCI-Report',
	#package : 'MooseCI-Report'
}

{ #category : 'accessing' }
MCIConsoleReportWriter class >> defaultFileName [

	^ ''
]

{ #category : 'executing' }
MCIConsoleReportWriter class >> fileExtension [

	^ ''
]

{ #category : 'formatting' }
MCIConsoleReportWriter class >> formatKey [

	^ #console
]

{ #category : 'writing' }
MCIConsoleReportWriter >> writeCriticsOn: aStream [

	| violations passed |
	violations := self report violations.
	passed := (violations select: [ :each | each isEmpty ]) size.

	aStream
		nextPutAll: (AnsiColor yellow: 'Quality (' , passed asString , '/' , violations size asString , ' passed)');
		lf.

	violations keysDo: [ :condition |
			| violationOutput |
			violationOutput := '    ' , (violations at: condition) size asString , ' ' , condition name.
			violationOutput := (violations at: condition) size = 0
				                   ifTrue: [ AnsiColor green: violationOutput ]
				                   ifFalse: [ AnsiColor red: violationOutput ].

			aStream
				nextPutAll: violationOutput;
				lf ]
]

{ #category : 'writing' }
MCIConsoleReportWriter >> writeMetricsOn: aStream [

	| metrics |
	metrics := self report metrics.
	(metrics isNil or: metrics isEmpty) ifTrue: [ ^ self ].
	aStream
		nextPutAll: (AnsiColor yellow: 'Metrics');
		lf.

	metrics keysAndValuesDo: [ :key :value |
			aStream
				nextPutAll: '    ' , value asString , ' ' , (MCIMetrics metricAt: key) metricName;
				lf ]
]

{ #category : 'writing' }
MCIConsoleReportWriter >> writeOn: aStream [

	self writeMetricsOn: aStream.
	self writeCriticsOn: aStream
]

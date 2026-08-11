Class {
	#name : 'MCIJSONReportWriter',
	#superclass : 'MCIReportWriter',
	#category : 'MooseCI-Report',
	#package : 'MooseCI-Report'
}

{ #category : 'executing' }
MCIJSONReportWriter class >> fileExtension [

	^ '.json'
]

{ #category : 'formatting' }
MCIJSONReportWriter class >> formatKey [

	^ #json
]

{ #category : 'as yet unclassified' }
MCIJSONReportWriter >> jsonObject [

	| violations |
	violations := self report violations.
	^ {
		  ('metrics' -> self metricsObject).
		  ('violations' -> (violations associations collect: [ :asso |
				    {
					    ('rule' -> asso key ruleName).
					    ('severity' -> asso key severity name).
					    ('count' -> asso value size).
					    ('entities' -> (asso value collect: [ :entity | entity name ])) 
					} ])) 
		} asDictionary
]

{ #category : 'writing' }
MCIJSONReportWriter >> jsonString [

	^ String streamContents: [ :stream | self writeOn: stream ]
]

{ #category : 'as yet unclassified' }
MCIJSONReportWriter >> metricsObject [

	| metrics |
	metrics := self report metrics.
	^ {
		  ('files' -> metrics files).
		  ('loc' -> metrics loc).
		  ('packages' -> metrics packages).
		  ('classes' -> metrics classes) 
		} asDictionary
]

{ #category : 'writing' }
MCIJSONReportWriter >> writeOn: aStream [

	aStream nextPutAll: (STONJSON toStringPretty: self jsonObject)
]

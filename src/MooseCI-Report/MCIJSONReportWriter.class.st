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

	| violations|
	violations := self report violations select: [:each | each isNotEmpty].
	"1halt."
	^ {
		  ('metrics' -> self metricsObject).
		  ('violations' -> 
			(violations associations collect: [ :asso |
				|entities|
				entities := (asso value collect: [ :violation | violation violatingEntity ]) asCollection collect: [:entity | entity mooseName].
				
				     {
					    ('rule' -> asso key name).
					    ('severity' -> asso key severity name).
					    ('count' -> asso value size).
					    ('entities' -> entities asArray ) 
					} asDictionary ])) 
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

	aStream nextPutAll: (STON toStringPretty: self jsonObject)
]

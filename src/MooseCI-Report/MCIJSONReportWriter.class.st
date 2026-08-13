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
MCIJSONReportWriter >> entityObject: anEntity [

	| anchor |
	anchor := anEntity sourceAnchor.

	^ OrderedDictionary newFrom: {
			  ('entity' -> anEntity name).
			  ('file' -> anchor fileName).
			  ('startLine' -> anchor startLine).
			  ('endLine' -> anchor endLine) }
]

{ #category : 'as yet unclassified' }
MCIJSONReportWriter >> jsonObject [

	| violations|
	violations := self report violations select: [:each | each isNotEmpty].
	
	^ OrderedDictionary newFrom: {
		  ('metrics' -> self metricsObject).
		  ('violations' -> 
			(violations associations collect: [ :asso |
				|entities|
				entities := (asso value collect: [ :violation | self entityObject: violation violatingEntity ]) .
				
				    OrderedDictionary newFrom: {
					    ('rule' -> asso key name).
					    ('severity' -> asso key severity title).
					    ('count' -> asso value size).
					    ('entities' -> entities asArray ) 
					} ])) 
		}
]

{ #category : 'writing' }
MCIJSONReportWriter >> jsonString [

	^ String streamContents: [ :stream | self writeOn: stream ]
]

{ #category : 'as yet unclassified' }
MCIJSONReportWriter >> metricsObject [

	| metrics |
	metrics := self report metrics.
	^ OrderedDictionary newFrom: {
		  ('files' -> metrics files).
		  ('loc' -> metrics loc).
		  ('packages' -> metrics packages).
		  ('classes' -> metrics classes) 
		}
]

{ #category : 'writing' }
MCIJSONReportWriter >> writeOn: aStream [

	aStream nextPutAll: (STONJSON toStringPretty: self jsonObject)
]

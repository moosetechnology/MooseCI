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

	| anchor located label target |
	located := anEntity.
	label := anEntity isAssociation
		         ifTrue: [
				         located := anEntity source.
				         target := anEntity target.
				         target isCollection ifTrue: [ target := target ifEmpty: [ nil ] ifNotEmpty: [ :c | c anyOne ] ].
				         anEntity source name , ' -> ' , (target ifNil: [ '?' ] ifNotNil: [ :t | t name ]) ]
		         ifFalse: [ anEntity name ].

	anchor := located sourceAnchor.

	^ OrderedDictionary newFrom: {
			  ('entity' -> label).
			  ('file' -> (anchor ifNotNil: [ anchor fileName ])).
			  ('startLine' -> (anchor ifNotNil: [ anchor startLine ])).
			  ('endLine' -> (anchor ifNotNil: [ anchor endLine ])) }
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
	^ (metrics associations collect: [ :association |
			   association key asString -> association value ]) asOrderedDictionary
]

{ #category : 'writing' }
MCIJSONReportWriter >> writeOn: aStream [

	aStream nextPutAll: (STONJSON toStringPretty: self jsonObject)
]

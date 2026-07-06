Class {
	#name : 'AnsiColor',
	#superclass : 'Object',
	#category : 'MooseCI-CLI',
	#package : 'MooseCI-CLI'
}

{ #category : 'coloring' }
AnsiColor class >> green: aString [
    ^ (Character escape asString), '[32m', aString, (Character escape asString), '[0m'
]

{ #category : 'coloring' }
AnsiColor class >> red: aString [
    ^ (Character escape asString), '[31m', aString, (Character escape asString), '[0m'
]

{ #category : 'coloring' }
AnsiColor class >> yellow: aString [
    ^ (Character escape asString), '[33m', aString, (Character escape asString), '[0m'
]

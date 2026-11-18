"
I test the validation of the #visualizations entries of moose-ci.ston (see MooseCIConfig>>#checkVisualizationsInto:).
"
Class {
	#name : 'MCIVisualizationConfigTest',
	#superclass : 'TestCase',
	#category : 'MooseCI-Visualizations-Tests',
	#package : 'MooseCI-Visualizations-Tests'
}

{ #category : 'helpers' }
MCIVisualizationConfigTest >> errorsFor: aStonList [

	^ (STON fromString: 'MooseCIConfig {
	#projectLanguage : #java,
	#rules : [ #unused_parameter ],
	#isRemote : false,
	#visualizations : ' , aStonList , '
}') validationErrors
]

{ #category : 'tests' }
MCIVisualizationConfigTest >> testMissingOf [

	self assert: (self errorsFor: '[ { #view : #dsm } ]') asArray equals: #( 'visualization 1 needs #of' )
]

{ #category : 'tests' }
MCIVisualizationConfigTest >> testUnknownKey [

	self
		assert: (self errorsFor: '[ { #view : #dsm, #of : #classes, #off : #packages } ]') asArray
		equals: #( 'Unknown key #off in visualization 1' )
]

{ #category : 'tests' }
MCIVisualizationConfigTest >> testUnknownSetting [

	self
		assert: (self errorsFor: '[ { #view : #dsm, #of : #classes, #settings : { #layout : #tree } } ]') asArray
		equals: #( 'Unknown setting #layout in visualization 1 (expected: shouldShowSelfDependencies)' )
]

{ #category : 'tests' }
MCIVisualizationConfigTest >> testUnknownView [

	self
		assert: (self errorsFor: '[ { #view : #pie, #of : #classes } ]') asArray
		equals: #( 'Unknown view #pie in visualization 1 (expected: architecturalMap dsm)' )
]

{ #category : 'tests' }
MCIVisualizationConfigTest >> testValidSettings [

	self assert: (self errorsFor: '[
		{ #view : #architecturalMap, #of : #packages, #settings : { #layout : #tree, #weightedLinks : true } },
		{ #view : #dsm, #of : #classes, #settings : { #shouldShowSelfDependencies : false } } ]') isEmpty
]

{ #category : 'tests' }
MCIVisualizationConfigTest >> testValidVisualizations [

	self assert: (self errorsFor: '[
		{ #view : #dsm, #of : #packages },
		{ #view : #architecturalMap, #of : #classes, #in : ''.*\\.ui\\..*'' } ]') isEmpty
]

{ #category : 'tests' }
MCIVisualizationConfigTest >> testWrongSettingValues [

	self
		assert: (self errorsFor: '[ { #view : #architecturalMap, #of : #packages, #settings : { #layout : #pie, #weightedLinks : 3 } } ]') asSet
		equals: #( 'Wrong value #pie for setting #layout in visualization 1 (expected: circle flow force grid tree)'
			   'Wrong value 3 for setting #weightedLinks in visualization 1 (expected: false true)' ) asSet
]

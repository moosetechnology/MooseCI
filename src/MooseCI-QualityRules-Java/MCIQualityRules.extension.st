Extension { #name : 'MCIQualityRules' }

{ #category : '*MooseCI-QualityRules-Java' }
MCIQualityRules class >> javaRules [

	^ {
		  (MCITooManyParametersRule key -> MCITooManyParametersRule defaultThresholds).
		  (MCILargeClassRule key -> MCILargeClassRule defaultThresholds).
		  MCIUnusedLocalVariableRule key.
		  MCIUnusedParameterRule key}
]

Extension { #name : 'MCIQualityRules' }

{ #category : '*MooseCI-QualityRules-Java' }
MCIQualityRules class >> javaRules [

	^ {
		  (MCITooManyParametersRule key -> MCITooManyParametersRule defaultThreshold).
		  (MCILargeClassRule key -> MCILargeClassRule defaultThreshold).
		  MCIUnusedLocalVariableRule key.
		  MCIUnusedParameterRule key}
]

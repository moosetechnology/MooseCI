Extension { #name : 'MCIQualityRules' }

{ #category : '*MooseCI-Corese' }
MCIQualityRules class >> coreseRules [

	^ {
		  (MCITooManyParametersRule key -> MCITooManyParametersRule defaultThresholds).
		  (MCILargeClassRule key -> MCILargeClassRule defaultThresholds).
		  MCICoreseUnusedLocalVariableRule key.
		  MCIUnusedParameterRule key}
]

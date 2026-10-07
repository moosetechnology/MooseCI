Extension { #name : 'MCIQualityRules' }

{ #category : '*MooseCI-Python' }
MCIQualityRules class >> pythonRules [

	^ {
		  (MCIPyLongFileRule key -> MCIPyLongFileRule defaultThresholds).
		  MCIPyNoDocstringRule key.
		  (MCITooManyParametersRule key -> MCITooManyParametersRule defaultThresholds).
		  (MCILargeClassRule key -> MCILargeClassRule defaultThresholds).
		  MCIPyLocalVariableNamingRule key.
		  MCIUnusedLocalVariableRule key.
		  MCIUnusedParameterRule key.
		  MCIPyUnusedPrivateMethodRule key.
		  MCIShadowedAttributeRule key.
		  MCIPyFunctionNamingRule key }
]

Extension { #name : 'MCIQualityRules' }

{ #category : '*MooseCI-QualityRules-Python' }
MCIQualityRules class >> pythonRules [

	^ {
		  (MCILongFileRule key -> MCILongFileRule defaultThreshold).
		  MCIPyNoDocstringRule key.
		  (MCITooManyParametersRule key -> MCITooManyParametersRule defaultThreshold).
		  (MCILargeClassRule key -> MCILargeClassRule defaultThreshold).
		  MCIPyLocalVariableNamingRule key.
		  MCIUnusedLocalVariableRule key.
		  MCIUnusedParameterRule key.
		  MCIPyUnusedPrivateMethodRule key.
		  MCIShadowedAttributeRule key.
		  MCIPyFunctionNamingRule key }
]

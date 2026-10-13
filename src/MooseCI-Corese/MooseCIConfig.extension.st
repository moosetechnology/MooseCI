Extension { #name : 'MooseCIConfig' }

{ #category : '*MooseCI-Corese' }
MooseCIConfig class >> corese [

	<mciConfigTemplate>
	^ self java
		  rules: MCIQualityRules coreseRules;
		  yourself
]

Extension { #name : 'MooseCIConfig' }

{ #category : '*MooseCI-Corese' }
MooseCIConfig class >> corese [

	^ self new
		  projectLanguage: #java;
		  metrics: MCIMetrics javaMetrics;
		  rules: MCIQualityRules coreseRules;
		  visualizations: #(  );
		  outputFormats: MCIReportWriter defaultOutputFormats;
		  outputPath: '.moose-ci/report';
		  isRemote: false;
		  yourself
]

Extension { #name : 'MooseCIConfig' }

{ #category : '*MooseCI-Core-Python' }
MooseCIConfig class >> python [

	^ self new
		  projectLanguage: #python;
		  metrics: MCIMetrics pythonMetrics;
		  rules: MCIQualityRules pythonRules;
		  visualizations: #(  );
		  outputFormats: MCIReportWriter defaultOutputFormats;
		  outputPath: '.moose-ci/report';
		  isRemote: false;
		  yourself
]

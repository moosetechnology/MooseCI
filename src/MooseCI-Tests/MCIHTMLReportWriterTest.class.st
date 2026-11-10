Class {
	#name : 'MCIHTMLReportWriterTest',
	#superclass : 'MCIReportTestCase',
	#category : 'MooseCI-Tests',
	#package : 'MooseCI-Tests'
}

{ #category : 'helpers' }
MCIHTMLReportWriterTest >> embeddedJsonIn: aString [

	| start |
	start := (aString indexOfSubCollection: '<script id="report" type="application/json">')
	         + '<script id="report" type="application/json">' size.
	^ aString copyFrom: start to: (aString indexOfSubCollection: '</script>' startingAt: start) - 1
]

{ #category : 'helpers' }
MCIHTMLReportWriterTest >> html [

	^ MCIHTMLReportWriter new
		  report: report;
		  html
]

{ #category : 'tests' }
MCIHTMLReportWriterTest >> testDropsSampleReport [

	self deny: (self html includesSubstring: 'MooseCIReport.sampleReport =')
]

{ #category : 'tests' }
MCIHTMLReportWriterTest >> testEmbedsReportJson [

	| json |
	json := STONJSON fromString: (self embeddedJsonIn: self html).

	self assert: (json includesKey: 'metrics').
	self assert: (json at: 'violations') notEmpty.
	self assert: ((json at: 'violations') allSatisfy: [ :group | group includesKey: 'category' ])
]

{ #category : 'tests' }
MCIHTMLReportWriterTest >> testFileExtension [

	self assert: MCIHTMLReportWriter fileExtension equals: '.html'
]

{ #category : 'tests' }
MCIHTMLReportWriterTest >> testInlinesStylesheetAndScripts [

	| html |
	html := self html.

	self deny: (html includesSubstring: 'href="report.css"').
	self deny: (html includesSubstring: '<script src=').
	self assert: (html includesSubstring: '<style>').
	self assert: (html includesSubstring: 'window.MooseCIReport')
]

{ #category : 'tests' }
MCIHTMLReportWriterTest >> testMissingTemplateFails [

	self
		should: [
				MCIHTMLReportWriter new
					report: report;
					templateDirectory: FileSystem memory root;
					html ]
		raise: MCIReportTemplateNotFoundError
]

{ #category : 'tests' }
MCIHTMLReportWriterTest >> testScriptSafeEscapesClosingTags [

	self assert: (MCIHTMLReportWriter new scriptSafe: '"</script>"') equals: '"<\/script>"'
]

{ #category : 'tests' }
MCIHTMLReportWriterTest >> testTemplateScriptsHaveNoClosingTag [

	| scripts |
	scripts := (MooseCIBridge htmlReportTemplate / 'js') files select: [ :file | file extension = 'js' ].

	self assert: scripts notEmpty.
	scripts do: [ :file | self deny: (file contents includesSubstring: '</script') description: file basename , ' contains </script' ]
]

{ #category : 'tests' }
MCIHTMLReportWriterTest >> testWriterAtHtml [

	self assert: (MCIReportWriter writerAt: #html) equals: MCIHTMLReportWriter
]

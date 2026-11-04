"
I write the analysis report as one self-contained HTML file.

I read the template in `ressources/html-report` (see `MooseCIBridge class>>#htmlReportTemplate`), inline its stylesheet and scripts, drop the development-only scripts, and put the JSON report into the `#report` slot of the page.

The page itself (HTML, CSS, JS) is edited in the template folder, not here.
"
Class {
	#name : 'MCIHTMLReportWriter',
	#superclass : 'MCIReportWriter',
	#instVars : [
		'templateDirectory'
	],
	#category : 'MooseCI-Report',
	#package : 'MooseCI-Report'
}

{ #category : 'formatting' }
MCIHTMLReportWriter class >> fileExtension [

	^ '.html'
]

{ #category : 'formatting' }
MCIHTMLReportWriter class >> formatKey [

	^ #html
]

{ #category : 'private' }
MCIHTMLReportWriter >> attribute: aName of: aTag [

	| matcher |
	matcher := (aName , '="([^"]*)"') asRegex.
	^ (matcher search: aTag)
		  ifTrue: [ matcher subexpression: 2 ]
		  ifFalse: [ nil ]
]

{ #category : 'accessing' }
MCIHTMLReportWriter >> developmentOnlyScripts [
	"Scripts of the template used to preview it, left out of the generated report"

	^ #( 'sample-report.js' )
]

{ #category : 'writing' }
MCIHTMLReportWriter >> embedReportIn: aString [

	(aString includesSubstring: self reportSlot) ifFalse: [
		MCIReportTemplateNotFoundError signal: 'index.html has no ' , self reportSlot , ' slot' ].

	^ aString
		  copyReplaceAll: self reportSlot
		  with: '<script id="report" type="application/json">' , (self scriptSafe: self reportJson) , '</script>'
]

{ #category : 'writing' }
MCIHTMLReportWriter >> html [
	"The report is embedded last, so nothing coming from the analyzed code is matched as a tag"

	^ self embedReportIn: (self inlineScriptsIn: (self inlineStylesheetsIn: (self templateNamed: 'index.html')))
]

{ #category : 'writing' }
MCIHTMLReportWriter >> inlineScriptsIn: aString [

	^ '<script src="[^"]+"></script>' asRegex copy: aString translatingMatchesUsing: [ :tag |
			  | src |
			  src := self attribute: 'src' of: tag.
			  (self developmentOnlyScripts includes: src)
				  ifTrue: [ '' ]
				  ifFalse: [ '<script>' , (self inlinedTemplateNamed: src closingTag: '</script') , '</script>' ] ]
]

{ #category : 'writing' }
MCIHTMLReportWriter >> inlineStylesheetsIn: aString [

	^ '<link rel="stylesheet" href="[^"]+">' asRegex
		  copy: aString
		  translatingMatchesUsing: [ :tag |
		  '<style>' , (self inlinedTemplateNamed: (self attribute: 'href' of: tag) closingTag: '</style') , '</style>' ]
]

{ #category : 'private' }
MCIHTMLReportWriter >> inlinedTemplateNamed: aPath closingTag: aTag [
	"Contents of a template file, to put inside a <style> or <script> element of the page"

	| contents |
	contents := self templateNamed: aPath.
	(contents includesSubstring: aTag) ifTrue: [ self error: aPath , ' contains ' , aTag , ' and cannot be inlined' ].
	^ contents
]

{ #category : 'private' }
MCIHTMLReportWriter >> reportJson [

	^ MCIJSONReportWriter new
		  report: self report;
		  jsonString
]

{ #category : 'accessing' }
MCIHTMLReportWriter >> reportSlot [

	^ '<script id="report" type="application/json"></script>'
]

{ #category : 'private' }
MCIHTMLReportWriter >> scriptSafe: aString [
	"No </script> inside the data can close the element holding it; \/ is a valid JSON escape"

	^ aString copyReplaceAll: '</' with: '<\/'
]

{ #category : 'accessing' }
MCIHTMLReportWriter >> templateDirectory [

	^ templateDirectory ifNil: [ MooseCIBridge htmlReportTemplate ]
]

{ #category : 'accessing' }
MCIHTMLReportWriter >> templateDirectory: aFileReference [

	templateDirectory := aFileReference
]

{ #category : 'private' }
MCIHTMLReportWriter >> templateNamed: aPath [

	| file |
	file := self templateDirectory / aPath.
	file exists ifFalse: [ MCIReportTemplateNotFoundError signal: 'HTML report template file not found: ' , file fullName ].
	^ file contents
]

{ #category : 'writing' }
MCIHTMLReportWriter >> writeOn: aStream [

	aStream nextPutAll: self html
]

Class {
	#name : 'MooseCIInitCommand',
	#superclass : 'ClapApplication',
	#category : 'MooseCI-CLI',
	#package : 'MooseCI-CLI'
}

{ #category : 'private - initialization' }
MooseCIInitCommand class >> init [

	<commandline>
	^ (ClapCommandSpec id: #init)
		  description: 'Initializing a configuration file for moose-ci';
		  commandClass: self;
		  addPositional: #template spec: [ :positional |
				  positional
					  description: 'Optional config template (e.g. java, python, corese)';
					  defaultValue: [ :arg :app | nil ] ];
		  addFlag: #list description: 'List the available config templates';
		  addHelp;
		  yourself
]

{ #category : 'as yet unclassified' }
MooseCIInitCommand >> configFromDetectedLanguage [

	| language |
	language := MooseCILanguageDetector detect: FileLocator workingDirectory.

	self outputStreamDo: [ :out |
			out
				lf;
				nextPutAll: 'Language detected: ';
				nextPutAll: language primary asString;
				lf;
				lf ].

	^ MooseCIConfig for: language primary
]

{ #category : 'as yet unclassified' }
MooseCIInitCommand >> createConfigFileFor: aSymbol [

	| config |
	
	config := MooseCIConfig for: aSymbol.
	
	FileLocator workingDirectory / MooseCIConfig configFileName writeStreamDo: [ :stream | stream nextPutAll: config toSton ]
]

{ #category : 'as yet unclassified' }
MooseCIInitCommand >> createDefaultStonConfigFile [

	| config |
	
	config := MooseCIConfig default.
	
	FileLocator workingDirectory / MooseCIConfig configFileName writeStreamDo: [ :stream | stream nextPutAll: config toSton ]
]

{ #category : 'execution' }
MooseCIInitCommand >> execute [

	| fileName |
	(self hasFlag: #list) ifTrue: [ ^ self listTemplates ].
	fileName := MooseCIConfig configFileName.

	self outputStreamDo: [ :out |
			out
				lf;
				nextPutAll: 'Creating a MooseCI config file...';
				lf;
				lf ].

	[
		| config |
		config := self resolveConfig.
		self writeConfig: config to: fileName.

		self outputStreamDo: [ :out |
				out
					nextPutAll: (AnsiColor green: 'Config written to ' , fileName);
					lf;
					lf;
					nextPutAll: 'Run `moose-ci analyze` to use it.';
					lf ].
		self exitSuccess ]
		on: Error
		do: [ :e |
				self outputStreamDo: [ :out |
						out
							nextPutAll: (AnsiColor red: 'Error while creating the config file: ');
							nextPutAll: e messageText;
							lf ].
				Exit signalFailure ]
]

{ #category : 'as yet unclassified' }
MooseCIInitCommand >> listTemplates [

	| templates |
	templates := MooseCIConfig templateNames.

	self outputStreamDo: [ :out |
			out
				lf;
				nextPutAll: 'Available config templates:';
				lf.
			templates
				ifEmpty: [
						out
							tab;
							nextPutAll: '(none)';
							lf ]
				ifNotEmpty: [
						templates do: [ :each |
								out
									tab;
									nextPutAll: (AnsiColor yellow: '- ', each asString);
									lf ] ] ].

	self exitSuccess
]

{ #category : 'as yet unclassified' }
MooseCIInitCommand >> resolveConfig [

	^ self template 
		ifNotNil: [ :name | MooseCIConfig configForTemplate: name asSymbol ] 
		ifNil: [ self configFromDetectedLanguage ]
]

{ #category : 'accessing' }
MooseCIInitCommand >> template [

	^ self positional: #template
]

{ #category : 'writing' }
MooseCIInitCommand >> writeConfig: aMooseCIConfig to: aFileName [

	FileLocator workingDirectory / aFileName writeStreamDo: [ :stream | stream nextPutAll: aMooseCIConfig toSton ]
]

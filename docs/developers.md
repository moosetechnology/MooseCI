# For developers

## Installation

Load Moose-CI in a Moose image with Metacello. The `default` group installs the core of Moose-CI with Java support:

```smalltalk
Metacello new
  baseline: 'MooseCI';
  repository: 'github://moosetechnology/MooseCI:master/src';
  load.
```

To also install Python support, load the `python` group:

```smalltalk
Metacello new
  baseline: 'MooseCI';
  repository: 'github://moosetechnology/MooseCI:master/src';
  load: #( 'default' 'python' ).
```

To install everything, load the `all` group:

```smalltalk
Metacello new
  baseline: 'MooseCI';
  repository: 'github://moosetechnology/MooseCI:master/src';
  load: #( 'all' ).
```

Available groups:

- `default`: core Moose-CI and Java support (installed by default).
- `python`: Python support (depends on `MoosePy` and `TreeSitter`).
- `all`: everything.

## Create a new rule

A rule is a subclass of `MCIAbstractQualityRule`. It must implement:

- `class >> key`: a unique identifier, e.g. `#too_many_lines`
- `class >> defaultThresholds`: an optional dictionary mapping threshold names to numbers, e.g. `{ #loc -> 500 } asDictionary` (empty by default)
- `contextFilterBlock`: a block that selects the entities to analyze
- `queryHandler`: a block that decides what counts as a violation

Example of a simple rule that reports files with too many lines of code:

```smalltalk
MCIAbstractQualityRule <<  #MCITooManyLinesRule
	slots: {};
	package: 'MooseCI-QualityRules'

MCITooManyLinesRule class >> key [
	^ #too_many_lines
]

MCITooManyLinesRule class >> defaultThresholds [
	^ { #loc -> 500 } asDictionary
]

MCITooManyLinesRule >> contextFilterBlock [
	^ [ :collection | collection select: [ :each | each isModule ] ]
]

MCITooManyLinesRule >> queryHandler [
	^ FamixCBQueryHandler on: (FQSelectScriptQuery script: [ :entity |
		entity numberOfLinesOfCode > (self thresholdAt: #loc) ])
]
```

You can also override `ruleName`, `defaultSeverity`, `applicableLanguages` and `description`. `applicableLanguages` is `#all` by default. You can specify it by passing a list of languages, e.g. `#( #python )`. Rules that do not define `defaultThresholds` have no thresholds (e.g. `#no_docstring`).

New rules are discovered automatically from their `key`, so no registration is needed. To use a rule, add its key to the `#rules` list in `moose-ci.ston`:

```ston
#rules : [
	#too_many_lines: { #loc: 300 },
	#no_docstring
]
```

- `#too_many_lines: { #loc: 300 }`: enables a rule and overrides its `#loc` threshold.
- `#no_docstring`: enables a rule that has no thresholds.

To make a rule part of the default config created by `moose-ci init`, add its key to `MCIQualityRules class >> pythonRules` (or `javaRules` / `defaultRules`).

## Create a new metric

A metric is a subclass of `MCIAbstractMetric`. It must implement:

- `class >> key`: a unique identifier, e.g. `#methods`
- `compute:`: a method that computes the value from a Moose model

Example of a simple metric that counts the number of methods:

```smalltalk
MCIAbstractMetric << #MCINumberOfMethodsMetric
	slots: {};
	package: 'MooseCI-Metrics'

MCINumberOfMethodsMetric class >> key [
	^ #methods
]

MCINumberOfMethodsMetric >> compute: aModel [
	^ aModel allMethods size
]
```

You can also override `metricName`, `description` and `applicableLanguages`. `metricName` defaults to the key as a string. `applicableLanguages` is `#all` by default. You can specify it by passing a list of languages, e.g. `#( #python )`.

New metrics are discovered automatically from their `key`, so no registration is needed. To use a metric, add its key to the `#metrics` list in `moose-ci.ston`:

```ston
#metrics : [
	#methods,
	#loc
]
```

Metrics can be empty (`#metrics : [ ]`) or omitted entirely when you do not want to compute any metric.

To make a metric part of the default config created by `moose-ci init`, add its key to `MCIMetrics class >> pythonMetrics` (or `javaMetrics` / `defaultMetrics`).

## Add a new language

Language support is organized as one package per language: `MooseCI-<Language>` holds the language-specific classes and class extensions, and `MooseCI-<Language>-Tests` holds its tests. To add a language, replace `<Language>` / `#mylang` below with your language symbol.

### 1. Detect the language

Register the file extensions so the language can be detected. Edit `MooseCILanguageDetector class >> extensionMap`:

```smalltalk
extensionMap at: 'ext' put: #mylang.
```

Optionally add language tool/build directories to `MooseCILanguageDetector class >> ignoredDirectoryNames`.

### 2. Provide a project loader

Subclass `MooseCIProjectLoader` in `MooseCI-<Language>`:

```smalltalk
MooseCIProjectLoader subclass: #MooseCIMylangProjectLoader
    ...

MooseCIMylangProjectLoader class >> languageNameSymbol [
    ^ #mylang
]

MooseCIMylangProjectLoader class >> load: aProjectFilePath [
    "Return a Moose model built from the project folder."
    ^ <Importer> import: aProjectFilePath asFileReference
]
```

Loaders are discovered automatically through `MooseCIProjectLoader forLanguage:` — no registration is needed.

### 3. Add a default config

Extend `MooseCIConfig` with a class method whose selector is the language symbol (`MooseCIConfig for:` uses `perform:`):

```smalltalk
Extension { #name : 'MooseCIConfig' }

MooseCIConfig class >> mylang [
    ^ self new
        projectLanguage: #mylang;
        metrics: MCIMetrics mylangMetrics;
        rules: MCIQualityRules mylangRules;
        visualizations: #(  );
        outputFormats: MCIReportWriter defaultOutputFormats;
        outputPath: '.moose-ci/report';
        isRemote: false;
        yourself
]
```

### 4. List the language's rules and metrics

Add `MCIQualityRules class >> mylangRules` and `MCIMetrics class >> mylangMetrics`, each returning a collection of keys:

```smalltalk
MCIQualityRules class >> mylangRules [
    ^ { (MCILargeClassRule key -> MCILargeClassRule defaultThresholds) }
]

MCIMetrics class >> mylangMetrics [
    ^ #( #classes )
]
```

Language-specific rule/metric classes must override `applicableLanguages` to return `#( #mylang )`; otherwise they default to `#all` and are accepted for every language. Config validation rejects a rule or metric whose `applicableLanguages` does not include the project language.

See [Create a new rule](#create-a-new-rule) and [Create a new metric](#create-a-new-metric) for how to write a rule or a metric.

### 5. Register the packages

In `BaselineOfMooseCI`:

- add the importer baseline to `defineDependencies:` if the language needs one;
- add `package: 'MooseCI-Mylang'` and `package: 'MooseCI-Mylang-Tests'` in `definePackages:`;
- add a group in `defineGroups:` and include it in `all`, e.g. `group: 'mylang' with: #( 'MooseCI-Mylang' 'MooseCI-Mylang-Tests' )`.

Then install it with:

```smalltalk
Metacello new
  baseline: 'MooseCI';
  repository: 'github://moosetechnology/MooseCI:master/src';
  load: #( 'default' 'mylang' ).
```

### 6. Add tests

Add tests in `MooseCI-<Language>-Tests` covering the config (`MooseCIConfig for: #mylang`), the loader (`MooseCIProjectLoader forLanguage: #mylang`), and the language rules/metrics.

### 7. Native importer dependencies

If the importer depends on native libraries, mirror the Python setup in `docker/` so the runtime image can load it.

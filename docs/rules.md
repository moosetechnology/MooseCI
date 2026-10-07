# Rules

## Available rules

| Key | Threshold | Description |
| --- | --- | --- |
| `#long_file` | `#loc: 1000` | Reports files whose number of lines of code exceeds the threshold. |
| `#no_docstring` | N/A | Reports functions, methods and classes that are missing a docstring. |
| `#too_many_parameters` | `#parameters: 10` | Reports methods whose number of parameters exceeds the threshold. |
| `#large_class` | `#methods: 20, #attributes: 15` | Reports classes that have too many methods or attributes. |
| `#local_var_naming` | N/A | Reports local variables and parameters whose names do not respect the naming convention. |
| `#unused_local_variable` | N/A | Reports local variables that are written but never read. |
| `#unused_parameter` | N/A | Reports function and method parameters that are never used. |
| `#unused_private_method` | N/A | Reports class-private methods that are never invoked. |
| `#shadowed_attribute` | N/A | Reports attributes whose name duplicates their containing class name. |
| `#function_naming` | N/A | Reports functions whose names do not comply with the naming convention. |

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

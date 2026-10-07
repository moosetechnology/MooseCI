# Metrics

## Available metrics

| Key | Description | Applicable languages |
| --- | --- | --- |
| `#files` | Number of source files. | all |
| `#loc` | Total lines of code. | all |
| `#packages` | Number of packages. | all |
| `#classes` | Number of classes. | all |

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

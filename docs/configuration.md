# Configuration

Moose-CI uses a `moose-ci.ston` config file. Run `moose-ci init` to create one.

## Report output

Running `analyze` prints the report to the console and writes it to files in the output directory (`.moose-ci/report/` by default, relative to the analyzed project).

By default a JSON report is written to `report-<TIMESTAMP>.json`:

```json
{
  "metrics" : {
    "files" : 8,
    "loc" : 5,
    "packages" : 2,
    "classes" : 3
  },
  "violations" : [
    {
      "rule" : "No docstring",
      "severity" : "Hint",
      "count" : 3,
      "entities" : [
        {
          "entity" : "DummyClass",
          "file" : "relative/path/to/no_docstring.py",
          "startLine" : 1,
          "endLine" : 2
        }
      ]
    }
  ]
}
```

Violations are grouped by rule. Each group contains the rule name, its severity, the number of violating entities and the details of each entity (name, file and source lines).

You can configure the output in `moose-ci.ston`:

```ston
#outputFormats : [
		#json
],
#outputPath : '.moose-ci/report'
```

- `#outputFormats`: list of formats to write. `#json` is the only format available for now.
- `#outputPath`: directory (relative to the project) where the report files are written.

## Rules

See the [available rules](rules.md).

You can update the rules list and customize each rule's thresholds:

```ston
...
#rules : [
		#long_file: { #loc: 1000 },
		#no_docstring,
		#too_many_parameters: { #parameters: 10 }
]
...
```

A rule that defines thresholds must use the dictionary form and must provide every one of its threshold keys. A missing key is reported as a validation error; a bare symbol is only valid for rules without thresholds.

## Metrics

See the [available metrics](metrics.md).

You can also choose which metrics to compute:

```ston
...
#metrics : [
		#files,
		#loc,
		#packages,
		#classes
]
...
```

Metrics can be omitted (or set to an empty list) if you do not want to compute any metric.

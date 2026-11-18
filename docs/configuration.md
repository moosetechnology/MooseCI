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
      "category" : "quality",
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

Only rules with at least one violation are listed. Violations are grouped by rule. Each group contains the rule name, its category (`quality`, or `architecture` for [architecture constraints](rules.md?id=architecture-constraints)), its severity, the number of violating entities and the details of each entity (name, file and source lines). For architecture rules, the entity is a dependency written `source -> target`.

You can configure the output in `moose-ci.ston`:

```ston
#outputFormats : [
		#json,
		#html
],
#outputPath : '.moose-ci/report'
```

- `#outputFormats`: list of formats to write: `#json` and `#html`. The HTML report (`report-<TIMESTAMP>.html`) is a single self-contained file that opens in any browser, with filters by severity and rule, and architecture constraints listed apart from quality rules.
- `#outputPath`: directory (relative to the project) where the report files are written.

After the report, `analyze` lists every file it wrote, relative to the project:

```
Generating report...
Generating visualizations...
Files
    .moose-ci/report/report-<TIMESTAMP>.json
    .moose-ci/report/report-<TIMESTAMP>.html
    .moose-ci/report/visualizations/1-dsm-packages.svg
```

`Generating visualizations...` is only printed when the config has [visualizations](#visualizations).

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

To check dependencies between modules, add the `#architecture` rule. See [Architecture constraints](rules.md?id=architecture-constraints).

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

## Visualizations

Moose-CI can export visualizations of [MooseIDE](https://github.com/moosetechnology/MooseIDE) as SVG files. Each entry of `#visualizations` writes one SVG, drawn by the MooseIDE browser of its view, without opening it:

```ston
...
#visualizations : [
		{ #view : #dsm, #of : #packages },
		{ #view : #dsm, #of : #classes, #in : '.*\\.ui\\..*' },
		{
			#view : #architecturalMap,
			#of : #packages,
			#in : 'example\\..+',
			#settings : { #layout : #tree, #weightedLinks : true }
		}
]
...
```

- `#view`: the visualization:
  - `#dsm`: Dependency Structure Matrix;
  - `#architecturalMap`: the entities nested in each other, with the dependencies between them.
- `#of`: the kind of entities shown: `#packages` or `#classes`. Stub entities (from libraries, not from your code) are left out.
- `#in` (optional): a regex on the entities' **mooseName**. It must match the whole mooseName, like the regexes of [architecture modules](rules.md?id=modules). Without `#in`, all the entities of that kind are shown.
- `#settings` (optional): settings of the view, see below.

`#visualizations` can be omitted (or set to an empty list) if you do not want any visualization.

### Settings

These are the settings of the MooseIDE browsers.

**`#architecturalMap`**

| Setting | Values | Default | Effect |
|---|---|---|---|
| `#layout` | `#flow`, `#circle`, `#grid`, `#tree`, `#force` | `#flow` | How the nodes are placed |
| `#weightedLinks` | `true`, `false` | `false` | Thicker lines, labelled with the number of dependencies |
| `#showDirectoriesAsRootNodes` | `true`, `false` | `false` | Group the top-level nodes by file directory |
| `#hideMegamorphicInvocations` | `true`, `false` | `false` | Hide calls to methods that have 10 or more implementations |
| `#hideReceivedEntities` | `true`, `false` | `false` | Show only the tags, not the entities |

**`#dsm`**

| Setting | Values | Default | Effect |
|---|---|---|---|
| `#shouldShowSelfDependencies` | `true`, `false` | `true` | Show the dependencies of an entity on itself |

### Output

The SVG files are written to `<outputPath>/visualizations/<N>-<view>-<of>.svg`, where `<N>` is the position of the entry in the list, for example `.moose-ci/report/visualizations/1-dsm-packages.svg`.

An entry whose view cannot show the selected entities is skipped, with a message in the console. If `#in` matches nothing, the SVG is written but empty: check the regex against the mooseNames.

> **Architectural map:** only the selected entities that have no parent among the selected entities are drawn, and their children are folded. If you select all packages, the map shows a single node: the top package. Select the packages *inside* it instead, for example `#in : 'example\\..+'`.

### Validation

The visualizations are validated with the rest of the config. An invalid entry stops `analyze` with an error such as:

- `Unknown view #pie in visualization 1 (expected: architecturalMap dsm)`
- `visualization 1 needs #of`
- `Unknown setting #layout in visualization 1 (expected: shouldShowSelfDependencies)`
- `Wrong value #pie for setting #layout in visualization 1 (expected: circle flow force grid tree)`

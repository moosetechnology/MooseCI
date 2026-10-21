# Rules

## Available rules

| Key | Threshold | Applicable languages | Description |
| --- | --- | --- | --- |
| `#long_file` | `#loc: 1000` | python | Reports files whose number of lines of code exceeds the threshold. |
| `#no_docstring` | N/A | python | Reports functions, methods and classes that are missing a docstring. |
| `#too_many_parameters` | `#parameters: 10` | java, python | Reports methods whose number of parameters exceeds the threshold. |
| `#large_class` | `#methods: 20, #attributes: 15` | java, python | Reports classes that have too many methods or attributes. |
| `#local_var_naming` | N/A | python | Reports local variables and parameters whose names do not respect the naming convention. |
| `#unused_local_variable` | N/A | java, python | Reports local variables that are written but never read. |
| `#unused_parameter` | N/A | java, python | Reports function and method parameters that are never used. |
| `#unused_private_method` | N/A | python | Reports class-private methods that are never invoked. |
| `#shadowed_attribute` | N/A | java, python | Reports attributes whose name duplicates their containing class name. |
| `#function_naming` | N/A | python | Reports functions whose names do not comply with the naming convention. |
| `#architecture` | `#modules`, `#constraints` | java | Checks dependencies between modules against architecture constraints. See [Architecture constraints](?id=architecture-constraints). |

## Architecture constraints

The `#architecture` rule checks the dependencies between parts of your code against rules you write in plain sentences. It is built on [DependencyConstraint](https://github.com/moosetechnology/DependencyConstraint).

```ston
#rules : [
		#unused_parameter,
		#architecture : {
			#modules : {
				#ui : '.*\\.ui\\..*',
				#domain : '.*\\.domain\\..*',
				#infra : '.*\\.infra\\..*'
			},
			#constraints : [
				'domain cannot depend infra',
				'ui must depend domain',
				'ui canOnly depend domain'
			]
		}
]
```

### Modules

`#modules` is a dictionary that maps a module name to a regex. An entity belongs to a module when its **mooseName** matches the regex.

> **The regex must match the whole mooseName.** In Java, mooseNames use `.` as the separator (`example.ui.Controller`, `example.ui.Controller.get(int)`). Write `'.*\\.ui\\..*'`, not `'ui'`, which matches nothing. In STON, a `\` is written `\\`.

### Constraints

Each constraint is a sentence of exactly four words:

```
<module> <verb> <dependency> <module>
```

| Verb | Meaning (`A <verb> <dependency> B`) |
| --- | --- |
| `cannot` | A must not depend on B. |
| `must` | A must depend on B at least once. |
| `canOnly` | A may depend on nothing else than B (and itself). |
| `onlyCan` | No module other than A may depend on B. |

| Dependency | Kind of association checked |
| --- | --- |
| `depend` | any dependency |
| `invoke` | method invocations |
| `access` | attribute and variable accesses |
| `reference` | type references |
| `inherit` | inheritance |

Each sentence is checked as its own rule with the **Error** severity, and the sentence is used as the rule name in the reports.

### Report

Each violation is a dependency (an association), shown as `source -> target`. The file and lines come from the source entity:

```json
{
  "rule" : "ui canOnly depend domain",
  "severity" : "Error",
  "count" : 1,
  "entities" : [
    {
      "entity" : "get -> load",
      "file" : "ui/Controller.java",
      "startLine" : 10,
      "endLine" : 12
    }
  ]
}
```

### Validation

The config is validated before the analysis. An invalid sentence stops `analyze` with an error such as:

- `Constraint 'ui depend domain' must be: <module> <verb> <dependency> <module>`
- `Unknown verb 'cant' in 'ui cant depend domain' (expected: cannot must canOnly onlyCan)`
- `Unknown dependency 'call' in 'ui cannot call infra' (expected: depend invoke access reference inherit)`
- `Unknown module 'web' in 'web cannot depend infra'`

It also reports a missing `#modules` or `#constraints`, an empty `#constraints`, and an invalid regex.

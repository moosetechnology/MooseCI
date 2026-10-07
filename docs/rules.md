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

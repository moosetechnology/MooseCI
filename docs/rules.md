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

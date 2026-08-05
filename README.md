# Moose-CI

Moose-CI runs automatic Moose analyses on software projects.

**Disclaimer:** This project is at a very early stage. It only has a few features and may contain bugs.

You can request features in the [issues tab](https://github.com/moosetechnology/MooseCI/issues).

## Table of Contents

- [Features](#features)
- [For users](#for-users)
  - [Usage with Docker](#usage-with-docker)
  - [Available commands](#available-commands)
  - [Configuration](#configuration)
  - [Available rules](#available-rules)
- [For developers](#for-developers)
  - [Installation](#installation)

## Features

Some of features it should offer:
- [x] run alone ("headless" mode)
- [x] load a project (either from command line or in a configuration file)
- [ ] accept projects inany programming language that Moose can handle (C, Java, Pharo, Python, Typescript,...)
- [ ] run a list of analyses (either "standard" ones, or some specified in a configuration file)
- [ ] output the results in an appropriate format (specified on command line or configuration file: text, JSON, XML, CSV,...)

Some metrics and analyses that are envisionned:
- [x] size (LOC, \# of classes,...)
- [x] report number of entities that fail the rules
- [ ] list too big classes (based on LOC or \# members)
- [ ] list too big methods/functions (based on LOC)
- [ ] list of too complex methods/functions (based on cyclomatic complexity)
- [ ] list of too large method/function APIs (\# number of parameters)
- [ ] packages/modules in cyclic dependencies
- [ ] list of code clones

In would be good to be able to output some visualizations already available in Moose:
- [ ] DSM (Dependency Structure Matrix)
- [ ] Architectural view
- [ ] System complexity
- [ ] Distribution map

<img width="640" height="380" alt="demo" src="https://github.com/user-attachments/assets/d2d15ecc-5afb-42b4-aaf0-292d1dc2ff90" />

## For users

### Usage with Docker

The easiest way to run Moose-CI is with Docker. You do not need Pharo or any other dependency.

First, pull the image:

```bash
docker pull ghcr.io/moosetechnology/moose-ci:latest
```

Moose-CI runs in an isolated container. Mount your project to `/src`:

```bash
docker run -v /path/to/your/project:/src ghcr.io/moosetechnology/moose-ci:latest analyze /src
```

For the current directory:

```bash
docker run -v "$(pwd):/src" ghcr.io/moosetechnology/moose-ci:latest analyze /src
```

### Available commands

- `init` — create a new moose-ci config file.
- `analyze` — analyze the current directory using the existing config file.
- `analyze <project-path>` — analyze the project.

### Configuration

Moose-CI uses a `moose-ci.ston` config file. Run `moose-ci init` to create one.

For now, you can only update the rules list:

```ston
...
#rules : [
		#long_file,
		#no_docstring,
		#too_many_parameters
]
...
```

### Available rules

| Key | Description |
| --- | --- |
| `#long_file` | Reports files whose number of lines of code exceeds the threshold. |
| `#no_docstring` | Reports functions, methods and classes that are missing a docstring. |
| `#too_many_parameters` | Reports methods whose number of parameters exceeds the threshold. |
| `#large_class` | Reports classes that have too many methods or attributes. |
| `#local_var_naming` | Reports local variables and parameters whose names do not respect the naming convention. |
| `#unused_local_variable` | Reports local variables that are written but never read. |
| `#unused_parameter` | Reports function and method parameters that are never used. |
| `#unused_private_method` | Reports class-private methods that are never invoked. |
| `#shadowed_attribute` | Reports attributes whose name duplicates their containing class name. |
| `#function_naming` | Reports functions whose names do not comply with the naming convention. |

## For developers

### Installation

Load MooseCI in a Moose image with Metacello:

```smalltalk
Metacello new
  baseline: 'MooseCI';
  repository: 'github://moosetechnology/MooseCI:master/src';
  load.
```

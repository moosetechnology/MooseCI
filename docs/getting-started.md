# Getting started

Moose-CI runs automatic [Moose](https://modularmoose.org/) analyses on software projects.

> **Disclaimer:** This project is at a very early stage. It only has a few features and may contain bugs.
> You can request features in the [issues tab](https://github.com/moosetechnology/MooseCI/issues).

## Features

Some of the features it should offer:

- [x] run alone ("headless" mode)
- [x] load a project (either from the command line or in a configuration file)
- [ ] accept projects in any programming language that Moose can handle (C, Java, Pharo, Python, TypeScript, ...)
- [ ] run a list of analyses (either "standard" ones, or some specified in a configuration file)
- [x] output the results as JSON, HTML and console text
- [ ] output the results in other formats (XML, CSV, ...)

Some metrics and analyses that are envisioned:

- [x] size (LOC, \# of classes, ...)
- [x] report the number of entities that fail the rules
- [x] list too-big classes (based on \# members)
- [ ] list too-big methods/functions (based on LOC)
- [ ] list too-complex methods/functions (based on cyclomatic complexity)
- [x] list too-large method/function APIs (\# number of parameters)
- [x] check dependencies between modules against [architecture constraints](rules.md?id=architecture-constraints)
- [ ] packages/modules in cyclic dependencies
- [ ] list of code clones

In the future it would be good to output some visualizations already available in Moose:

- [ ] DSM (Dependency Structure Matrix)
- [ ] Architectural view
- [ ] System complexity
- [ ] Distribution map

<img width="640" height="380" alt="demo" src="https://github.com/user-attachments/assets/d2d15ecc-5afb-42b4-aaf0-292d1dc2ff90" />

## Usage with Docker

The easiest way to run Moose-CI is with Docker. You do not need Pharo or any other dependency.

Moose-CI is published as one image per language. Pick the image that matches your project:

- Java project → `ghcr.io/moosetechnology/moose-ci:latest` (the base image, which includes Java by default).
- Python project → `ghcr.io/moosetechnology/moose-ci:python` (the base image plus Python support).

Each [release](https://github.com/moosetechnology/MooseCI/releases) also has its own images, `moose-ci:<version>` and `moose-ci:<version>-python` (for example `moose-ci:v0.2.1`). Use them to keep the same Moose-CI version over time. The documentation of a release is available from the version menu.

First, pull the image you need (the Java image below; for a Python project, use the Python image above):

```bash
docker pull ghcr.io/moosetechnology/moose-ci:latest
```

From the project directory, initialize it as a Moose-CI project. This creates a `moose-ci.ston` config file that you can customize:

```bash
docker run -v "$(pwd):/src" ghcr.io/moosetechnology/moose-ci:latest init
```

Then run the analysis with the `analyze` command:

```bash
docker run -v "$(pwd):/src" ghcr.io/moosetechnology/moose-ci:latest analyze
```

You can also run Moose-CI on a project without initializing a config file by passing the project path:

```bash
docker run -v /path/to/your/project:/src ghcr.io/moosetechnology/moose-ci:latest analyze /src
```

The project is mounted in the container at `/src`, so you need to pass that path to the `analyze` command.

For a Python project, use the Python image in all the commands above.

### Available commands

- `init`: create a new moose-ci config file.
- `analyze`: analyze the current directory using the existing config file.
- `analyze <project-path>`: analyze the project.

## Usage with GitHub Actions

You can run Moose-CI in CI with the [Setup MooseCI GitHub Action](https://github.com/moosetechnology/setup-MooseCI). Add the action to a workflow:

```yaml
name: MooseCI
on: [push, pull_request]
permissions:
  contents: read
  actions: write
  pull-requests: write
jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: moosetechnology/setup-MooseCI@v2
        with:
          project-path: .
          project-language: java
```

- `project-language` (required): `java` or `python`. It selects the Moose-CI Docker image.
- `project-path`: the folder to analyze, relative to the workspace. Default: `.`
- `mooseci-version`: the Moose-CI release to use, e.g. `v0.2.1`. Each version of the action has its own default; see the [action's README](https://github.com/moosetechnology/setup-MooseCI).
- `comment-on-pr`: `"false"` to not comment on pull requests. Default: `"true"`.
- `actions: write` is needed to upload the report artifact.
- `pull-requests: write` is needed to comment the report link on pull requests.
- The `moose-ci.ston` config file must be placed inside the analyzed project folder (see [Configuration](configuration.md)).
- The JSON and HTML reports (the formats listed in `#outputFormats`) are uploaded as the `moose-ci-report` artifact.
- On pull requests, the action comments the report download URL and the analysis summary on the PR.

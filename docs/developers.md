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

See [Rules](rules.md) and [Metrics](metrics.md) for how to write a rule or a metric.

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

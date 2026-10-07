# Moose-CI

Moose-CI runs automatic [Moose](https://modularmoose.org/) analyses on software projects.

**Disclaimer:** This project is at a very early stage. It only has a few features and may contain bugs. You can request features in the [issues tab](https://github.com/moosetechnology/MooseCI/issues).

<img width="640" height="380" alt="demo" src="https://github.com/user-attachments/assets/d2d15ecc-5afb-42b4-aaf0-292d1dc2ff90" />

## Quick start

The easiest way to run Moose-CI is with Docker (no Pharo or other dependency needed):

```bash
# Java project (use :python for a Python project)
docker pull ghcr.io/moosetechnology/moose-ci:latest

docker run -v "$(pwd):/src" ghcr.io/moosetechnology/moose-ci:latest init
docker run -v "$(pwd):/src" ghcr.io/moosetechnology/moose-ci:latest analyze
```

## Documentation

Full documentation is available at **https://modularmoose.org/MooseCI/** (source in [`docs/`](docs/)):

- [Getting started](https://modularmoose.org/MooseCI/#/getting-started)
- [Configuration](https://modularmoose.org/MooseCI/#/configuration)
- [Rules](https://modularmoose.org/MooseCI/#/rules)
- [Metrics](https://modularmoose.org/MooseCI/#/metrics)
- [For developers](https://modularmoose.org/MooseCI/#/developers)

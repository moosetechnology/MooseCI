# Moose-CI

A project to run automatic Moose analyses on software projects.

Some of features it should offer:
- run alone ("headless" mode)
- load a project (either from command line or in a configuration file)
- accept projects inany programming language that Moose can handle (C, Java, Pharo, Python, Typescript,...)
- run a list of analyses (either "standard" ones, or some specified in a configuration file)
- output the results in an appropriate format (specified on command line or configuration file: text, JSON, XML, CSV,...)

Some metrics and analyses that are envisionned:
- size (LOC, \# of classes,...)
- list too big classes (based on LOC or \# members)
- list too big methods/functions (based on LOC)
- list of too complex methods/functions (based on cyclomatic complexity)
- list of too large method/function APIs (\# number of parameters)
- packages/modules in cyclic dependencies
- list of code clones

In would be good to be able to output some visualizations already available in Moose:
- DSM (Dependency Structure Matrix)
- Architectural view
- System complexity
- Distribution map

<img width="600" height="400" alt="mooseci" src="https://github.com/user-attachments/assets/ff7b897a-ccd9-4252-93d0-ede1f37a2987" />

Metacello new
  baseline: 'MooseCI';
  repository: 'github://moosetechnology/MooseCI:master/src';
  load.

Metacello new
  baseline: 'TreeSitter';
  repository: 'github://Evref-BL/Pharo-Tree-Sitter:main/src';
  load: #('python').


TSLibrariesPython new generateTreeSitterLibrary
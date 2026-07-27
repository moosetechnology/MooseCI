Extension { #name : 'TSLanguage' }

{ #category : '*MooseCI-TreeSitter-Libs' }
TSLanguage class >> python [
	 
	^ TSPythonLibrary uniqueInstance tree_sitter_python
]

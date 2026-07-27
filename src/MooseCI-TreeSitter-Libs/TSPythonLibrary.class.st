Class {
	#name : 'TSPythonLibrary',
	#superclass : 'FFILibrary',
	#category : 'MooseCI-TreeSitter-Libs',
	#package : 'MooseCI-TreeSitter-Libs'
}

{ #category : 'accessing - platform' }
TSPythonLibrary >> macLibraryName [ 
	"Users should use unix32* or unix64*"

	^ FFIMacLibraryFinder findAnyLibrary: #( 'libtree-sitter-python.dylib' )  
]

{ #category : 'as yet unclassified' }
TSPythonLibrary >> tree_sitter_python [

	^ self ffiCall: 'TSLanguage * tree_sitter_python ()'
]

{ #category : 'as yet unclassified' }
TSPythonLibrary >> uniqueInstance [

	TSLibrariesPython new ensureTreeSitterLibraryExists.
	^ self
]

{ #category : 'as yet unclassified' }
TSPythonLibrary >> unix64LibraryName [
	"Users should use unix32* or unix64*"

	^ FFIUnix64LibraryFinder findAnyLibrary:
		  #( 'libtree-sitter-python.so' )
]

{ #category : 'as yet unclassified' }
TSPythonLibrary >> win32LibraryName [

	^ FFIWindowsLibraryFinder findAnyLibrary: #( 'libtree-sitter-python.dll' )
]

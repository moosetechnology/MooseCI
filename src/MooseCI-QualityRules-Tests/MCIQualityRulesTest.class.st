Class {
	#name : 'MCIQualityRulesTest',
	#superclass : 'TestCase',
	#instVars : [
		'javaModel',
		'tempFolders'
	],
	#category : 'MooseCI-QualityRules-Tests',
	#package : 'MooseCI-QualityRules-Tests'
}

{ #category : 'helpers' }
MCIQualityRulesTest >> javaProjectFrom: aString [
	"Create a temporary folder containing a Main.java file with the given source code, and return the absolute folder path."

	| folder |
	folder := FileLocator temp / UUID new asString.
	folder ensureCreateDirectory.
	(folder / 'Main.java') writeStreamDo: [ :stream | stream nextPutAll: aString ].
	tempFolders add: folder.
	^ folder fullName
]

{ #category : 'running' }
MCIQualityRulesTest >> setUp [
	super setUp.

	javaModel := FamixJavaModel new.
	tempFolders := OrderedCollection new.
]

{ #category : 'running' }
MCIQualityRulesTest >> tearDown [
	tempFolders do: [ :folder | folder exists ifTrue: [ folder ensureDeleteAll ] ].
	super tearDown
]

{ #category : 'tests' }
MCIQualityRulesTest >> testAllRules [

	| rules |
	rules := MCIQualityRules allRules.

	self assert: rules size equals: MCIAbstractQualityRule subclasses size.
	self assert: (rules allSatisfy: [ :rule | rule superclass = MCIAbstractQualityRule  ]).
]

{ #category : 'tests' }
MCIQualityRulesTest >> testDefaultApplicableLanguagesIsAll [

	self assert: MCIAbstractQualityRule applicableLanguages equals: #all
]

{ #category : 'tests' }
MCIQualityRulesTest >> testMCILargeClassRule [

	| javaViolations class method rule |
	class := FamixJavaClass new
		         name: 'AJavaLargeClass';
		         yourself.
	method := FamixJavaMethod new
		          name: 'aMethod';
		          yourself.
	class addMethod: method.

	javaModel
		add: method;
		add: class.
	rule := MCILargeClassRule new.
	rule thresholds: { (#methods -> 0). (#attributes -> 0) } asDictionary.
	javaViolations := MCIQualityRules runRules: { rule } on: javaModel.

	self assert: javaViolations isNotNil
]

{ #category : 'tests' }
MCIQualityRulesTest >> testMCITooManyParametersRule [

	| javaViolations method rule param |
	method := FamixJavaMethod new
		          name: 'aMethod';
		          yourself.
	param := FamixJavaParameter new
		         name: 'aParam';
		         yourself.
	method addParameter: param.

	javaModel
		add: method;
		add: param.
	rule := MCITooManyParametersRule new.
	rule thresholds: { #parameters -> 0 } asDictionary.
	javaViolations := MCIQualityRules runRules: { rule } on: javaModel.

	self assert: javaViolations isNotNil.
	self assert: javaViolations values first size equals: 1.
]

{ #category : 'tests' }
MCIQualityRulesTest >> testMCIUnusedLocalVariableRule [

	| javaViolations rule code|
	
	code := '
	public class VerveineJMain {

	public static void main(String[] args) {
		VerveineJParser parser = new VerveineJParser();
		parser.configure(args);
		int a = 0;
	}

}
	'.
	
	javaModel := MooseCIJavaProjectLoader  load: (self javaProjectFrom: code).
			
	rule := MCIUnusedLocalVariableRule new.
	
	javaViolations := MCIQualityRules runRules: { rule } on: javaModel.

	self assert: javaViolations isNotNil.
	self assert: javaViolations values first size equals: 1.
]

{ #category : 'tests' }
MCIQualityRulesTest >> testMCIUnusedLocalVariableRule2 [

	| javaViolations rule code|
	
	code := '
	public static  IBinding getDeclarationBinding(AbstractTypeDeclaration node) {
        IBinding bnd = node.resolveBinding();

        if (bnd == null) {
            bnd = StubBinding.getBinding(node);
        }

        return bnd;
    }
	'.
	
	javaModel := MooseCIJavaProjectLoader  load: (self javaProjectFrom: code).
			
	rule := MCIUnusedLocalVariableRule new.
	
	javaViolations := MCIQualityRules runRules: { rule } on: javaModel.

	self assert: javaViolations isNotNil.
	self assert: javaViolations values first size equals: 0.
]

{ #category : 'tests' }
MCIQualityRulesTest >> testMCIUnusedParameterRule [

	| javaViolations rule |
	
	(javaModel newMethodNamed: 'aMethod') addParameter: (FamixJavaParameter new
			 name: 'aParam';
			 yourself).

	rule := MCIUnusedParameterRule new.

	javaViolations := MCIQualityRules runRules: { rule } on: javaModel.

	self assert: javaViolations isNotNil.
	self assert: javaViolations values first size equals: 1
]

{ #category : 'tests' }
MCIQualityRulesTest >> testRuleAt [

	| aRuleClass |
	aRuleClass := MCIAbstractQualityRule subclasses first.


	self assert: (MCIQualityRules ruleAt: aRuleClass key) equals: aRuleClass
]

{ #category : 'tests' }
MCIQualityRulesTest >> testRuleAtNotFound [

	| rule |
	self assertBlock: [ rule := MCIQualityRules ruleAt: #a_non_existing_rule_key ] raises: MCIQualityRuleNotFoundError
]

{ #category : 'tests' }
MCIQualityRulesTest >> testRulesAt [

	| rules |
	rules := MCIAbstractQualityRule subclasses sliceTo: 2.

	self assert: rules size equals: 2.
	self assert: (rules allSatisfy: [ :rule | rule superclass = MCIAbstractQualityRule  ]).
]

{ #category : 'tests' }
MCIQualityRulesTest >> testDefaultThresholdsIsEmptyDictionary [

	| rule |
	rule := MCIUnusedLocalVariableRule new.

	self assert: rule thresholds isDictionary.
	self assert: rule thresholds isEmpty
]

{ #category : 'tests' }
MCIQualityRulesTest >> testThresholdsAreNotSharedBetweenInstances [

	| first second |
	first := MCILargeClassRule new.
	second := MCILargeClassRule new.
	first thresholds at: #methods put: 42.

	self assert: (second thresholds at: #methods) equals: 20
]

{ #category : 'tests' }
MCIQualityRulesTest >> testLargeClassDefaultThresholds [

	self assert: MCILargeClassRule new thresholds equals: { (#methods -> 20). (#attributes -> 15) } asDictionary
]

{ #category : 'tests' }
MCIQualityRulesTest >> testTooManyParametersDefaultThresholds [

	self assert: MCITooManyParametersRule new thresholds equals: { #parameters -> 10 } asDictionary
]

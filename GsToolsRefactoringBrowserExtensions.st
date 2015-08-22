<?xml version="1.0"?>

<st-source>
<time-stamp>From VisualWorks®, Release 5i.4 of August 9, 2001 on March 29, 2002 at 6:18:19 am</time-stamp>
<!-- Package GsToolsRefactoringBrowserExtensions(3.2.1,sourcecontrol) -->




<class>
<name>GsFormattedCodeStream</name>
<environment>Core</environment>
<super>Core.Object</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>stream tabs </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>Parser</category>
<attributes>
<package>GsToolsRefactoringBrowserExtensions</package>
</attributes>
</class>

<class>
<name>GsFormatter</name>
<environment>Core</environment>
<super>Refactory.Browser.RBProgramNodeVisitor</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars>codeStream </inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>Parser</category>
<attributes>
<package>GsToolsRefactoringBrowserExtensions</package>
</attributes>
</class>





<methods>
<class-id>Tools.MethodCollector</class-id> <category>interfaces</category>

<body package="GsToolsRefactoringBrowserExtensions">openListBrowserOn: aCollection
	label: labelString
	initialSelection: selector
	selectingClass: aClassOrNil
	andSelector: aSymbolOrNil
	"Create and schedule a browser on the collection of messages aCollection.
	 Label the topview labelString. If the collection is empty, warn the user.
	 If aClassOrNil is a class, and the list contains the selector in that class, then
	 it should initially come up with that entry selected. Answer the new browser."
	
	| aBrowser mc |
	aCollection isEmpty 
		ifTrue: [^Dialog warn: 'Nobody'].
	mc := 
		browser == nil 
			ifTrue: [FullSystemBrowser]
			ifFalse: [browser class listBrowserClass].
	SmalltalkWorkbench useRefactoringBrowser 
		ifTrue: 
			[^Refactory.Browser.RefactoringBrowser 
				openListBrowserOn: aCollection
				label: labelString
				initialSelection: selector
				spawnedFrom: aClassOrNil].
	aBrowser := 
		mc new 
			initializeForMethodsLabel: labelString
			list: aCollection
			initialSelection: selector.
	aBrowser open.
	^aBrowser</body>
</methods>


<methods>
<class-id>Core.GsFormatter class</class-id> <category>initialize-release</category>

<body package="GsToolsRefactoringBrowserExtensions">release
	
	[(((Smalltalk at: #Refactory) at: #Browser) at: #RBProgramNode) formatterClass: nil] 
		on: Error
		do: [:error | ]</body>

<body package="GsToolsRefactoringBrowserExtensions">initialize
	
	[(((Smalltalk at: #Refactory) at: #Browser) at: #RBProgramNode) formatterClass: self] 
		on: Error
		do: [:error | ]</body>
</methods>


<methods>
<class-id>Core.GsFormatter</class-id> <category>initialize-release</category>

<body package="GsToolsRefactoringBrowserExtensions">initialize
	"Refactory.Browser.RBProgramNode formatterClass: self"
	"Refactory.Browser.RBProgramNode formatterClass: nil"

	super initialize.
	self codeStream: GsFormattedCodeStream new.</body>
</methods>

<methods>
<class-id>Core.GsFormatter</class-id> <category>options</category>

<body package="GsToolsRefactoringBrowserExtensions">selectorsToStartOnNewLine

	^#(#whileTrue: #whileFalse: #ensure: #valueOnUnwindDo: #ifTrue: #ifFalse:)</body>

<body package="GsToolsRefactoringBrowserExtensions">maxLineSize

	^85</body>

<body package="GsToolsRefactoringBrowserExtensions">selectorsToLeaveOnLine

	^#(#at:put:)</body>

<body package="GsToolsRefactoringBrowserExtensions">shouldRemoveComments

	^false</body>
</methods>

<methods>
<class-id>Core.GsFormatter</class-id> <category>visitor-double dispatching</category>

<body package="GsToolsRefactoringBrowserExtensions">acceptMethodNode: aMethodNode
	"method pattern"
	
	self formatMethodSignature: aMethodNode.
	self indentWhile: 
		[self formatMethodCommentFor: aMethodNode.
		self tagBeforeTemporaries 
			ifTrue: [self formatTagFor: aMethodNode].
		self codeStream crAndIndent.
		self codeStream crAndIndent.
		aMethodNode body statements isEmpty 
			ifFalse: [self visitNode: aMethodNode body]]</body>

<body package="GsToolsRefactoringBrowserExtensions">acceptPatternWrapperBlockNode: aRBPatternWrapperBlockNode
	
	self visitNode: aRBPatternWrapperBlockNode wrappedNode.
	self 
		acceptBlockNode: aRBPatternWrapperBlockNode
		startBlockString: '`{'
		endBlockString: '}'</body>

<body package="GsToolsRefactoringBrowserExtensions">acceptSequenceNode: aSequenceNode
	
	self formatMethodCommentFor: aSequenceNode.
	self formatTemporariesFor: aSequenceNode.
	self formatStatementsFor: aSequenceNode</body>

<body package="GsToolsRefactoringBrowserExtensions">acceptCascadeNode: aCascadeNode
	
	| messages |
	messages := aCascadeNode messages.
	self visitNode: messages first receiver.
	self indentWhile: 
		[self 
			for: messages
			do: 
				[:each | 
				self codeStream crAndIndent.
				self formatCascadeMessage: each]
			separatedBy: [self codeStream nextPut: $;]]</body>

<body package="GsToolsRefactoringBrowserExtensions">acceptMessageNode: aMessageNode
	
	| code numberOfTabsOnLastLine oldTabs |
	code := self copy format: aMessageNode receiver.
	self codeStream nextPutAll: code.
	self codeStream space.
	numberOfTabsOnLastLine := 
		self numberOfLeadingTabsIn: 
			(self 
				findToken: Character cr
				inString: code) last.
	numberOfTabsOnLastLine := numberOfTabsOnLastLine max: self codeStream tabs.
	oldTabs := self codeStream tabs.
	self codeStream tabs: numberOfTabsOnLastLine.
	self formatMessage: aMessageNode.
	self codeStream tabs: oldTabs</body>

<body package="GsToolsRefactoringBrowserExtensions">acceptReturnNode: aReturnNode

	self codeStream nextPut: $^.
	self visitNode: aReturnNode value</body>

<body package="GsToolsRefactoringBrowserExtensions">acceptPatternBlockNode: aRBPatternBlockNode
	
	self 
		acceptBlockNode: aRBPatternBlockNode
		startBlockString: '`{'
		endBlockString: '}'</body>

<body package="GsToolsRefactoringBrowserExtensions">acceptOptimizedNode: anOptimizedNode
	
	codeStream nextPutAll: '##('.
	self visitNode: anOptimizedNode body.
	codeStream nextPut: $)</body>

<body package="GsToolsRefactoringBrowserExtensions">acceptAssignmentNode: anAssignmentNode
	
	| valueCode muliLine formatter |
	self visitNode: anAssignmentNode variable.
	self codeStream nextPutAll: ' := '.
	formatter := self copy.
	formatter codeStream tabs: 0.
	valueCode := formatter format: anAssignmentNode value.
	muliLine := 
		(self 
			findToken: Character cr
			inString: valueCode) size &gt; 1.
	muliLine 
		ifTrue: 
			[self codeStream 
				nextPutAllLines: valueCode
				maxSize: self maxLineSize]
		ifFalse: [self codeStream nextPutAll: valueCode]</body>

<body package="GsToolsRefactoringBrowserExtensions">acceptBlockNode: aBlockNode

	self 
		acceptBlockNode: aBlockNode
		startBlockString: '['
		endBlockString: ']'</body>

<body package="GsToolsRefactoringBrowserExtensions">acceptVariableNode: aVariableNode
	
	self codeStream nextPutAll: aVariableNode name</body>

<body package="GsToolsRefactoringBrowserExtensions">acceptBlockNode: aBlockNode
	startBlockString: startBlockString
	endBlockString: endBlockString
	
	| seqNode formattedBody isMultiLine |
	seqNode := aBlockNode body.
	formattedBody := self copy format: seqNode.
	self codeStream nextPutAll: startBlockString.
	isMultiLine := 
		(self 
			findToken: Character cr
			inString: formattedBody) size &gt; 1.
	aBlockNode arguments do: 
		[:each | 
		self codeStream nextPut: $:.
		self visitNode: each.
		self codeStream nextPut: $ ].
	aBlockNode arguments isEmpty 
		ifFalse: 
			[self codeStream nextPutAll: '| '.
			isMultiLine 
				ifTrue: [self codeStream crAndIndent]].
	self codeStream nextPutAll: formattedBody.
	self codeStream nextPutAll: endBlockString</body>

<body package="GsToolsRefactoringBrowserExtensions">acceptLiteralNode: aLiteralNode

	^self formatLiteralNode: aLiteralNode</body>
</methods>

<methods>
<class-id>Core.GsFormatter</class-id> <category>accessing</category>

<body package="GsToolsRefactoringBrowserExtensions">codeStream: anObject
	codeStream := anObject</body>

<body package="GsToolsRefactoringBrowserExtensions">codeStream
	^codeStream</body>

<body package="GsToolsRefactoringBrowserExtensions">format: aNode 
	self visitNode: aNode.
	^self codeStream contents</body>
</methods>

<methods>
<class-id>Core.GsFormatter</class-id> <category>copying</category>

<body package="GsToolsRefactoringBrowserExtensions">postCopy
	
	| oldCodeStreamTabs |
	super postCopy.
	oldCodeStreamTabs := self codeStream tabs.
	self codeStream: GsFormattedCodeStream new.
	self codeStream tabs: oldCodeStreamTabs</body>
</methods>

<methods>
<class-id>Core.GsFormatter</class-id> <category>example</category>

<body package="GsToolsRefactoringBrowserExtensions">exampleMethod4
	"this is a comment"
	"this is a comment"
	
	| dictionary |
	dictionary := 
		Dictionary new
			at: 'something'
				put: 
					[:oneArg | 
					oneArg
						name;
						size;
						printString];
			at: 'monty' put: 1;
			at: 'monty' put: 1;
			yourself.
	dictionary at: 'monty' put: 1.
	dictionary 
		at: 'something'
		put: 
			[:oneArg | 
			oneArg
				name;
				size;
				printString]</body>

<body package="GsToolsRefactoringBrowserExtensions">exampleMethod3
	
	self name.
	self age.
	self eat</body>

<body package="GsToolsRefactoringBrowserExtensions">exampleMethod2
	
	true 
		ifTrue: [self test].
	true 
		ifTrue: [self test].
	true 
		ifTrue: [self test].</body>

<body package="GsToolsRefactoringBrowserExtensions">exampleMethod: one
	"this is a comment"
	"this is a comment"
	
	| test |
	^self name size = 123123123123123123 
		ifTrue: 
			[[| name |
			name := self size.
			name size] 
				ensure: 
					[self class
						name;
						size;
						name;
						yourself]]
		ifFalse: 
			[[^(test := 1 + 3 + 4) 
				ifTrue: [true]
				ifFalse: [nil]] 
					on: Error
					do: [:error | ^self size]]</body>

<body package="GsToolsRefactoringBrowserExtensions">exampleMethod: one
	with: two
	with: three
	"this is a comment"
	"This is one 
	with a cr"
	&lt;pragmas: #instance&gt;
	
	| test |
	^(self name
		size;
		age;
		name) = 0 
			ifTrue: 
				[[| name |
				name := self size.
				name size] 
					ensure: 
						[self class
							name;
							size;
							name;
							yourself]]
			ifFalse: 
				[[^(test := 1 + 3 + 4) 
					ifTrue: [true]
					ifFalse: [nil]] 
						on: Error
						do: [:error | ^self size]]</body>
</methods>

<methods>
<class-id>Core.GsFormatter</class-id> <category>utility</category>

<body package="GsToolsRefactoringBrowserExtensions">formatSymbol: aSymbol 
	"Format the symbol, if its not a selector then we must put quotes around it. The and: case below, 
	handles the VisualWorks problem of not accepting two bars as a symbol."

	self codeStream nextPut: $#.
	((Refactory.Browser.RBScanner isSelector: aSymbol) and: [aSymbol ~~ #'||']) 
		ifTrue: [self codeStream nextPutAll: aSymbol]
		ifFalse: [aSymbol asString printOn: codeStream]</body>

<body package="GsToolsRefactoringBrowserExtensions">formatLiteral: aValue
	
	| isArray |
	(isArray := aValue class == Array) | (aValue class == ByteArray) ifTrue: 
		[self codeStream nextPutAll: 
			(isArray 
				ifTrue: ['#(']
				ifFalse: ['#[']).
		self 
			for: aValue
			do: 
				[:each | 
				self formatLiteral: each]
			separatedBy: [self codeStream nextPut: $ ].
		self codeStream nextPut: 
			(isArray 
				ifTrue: [$)]
				ifFalse: [$]]).
		^self].
	aValue isSymbol ifTrue: 
		[self formatSymbol: aValue.
		^self].
	aValue class == Character ifTrue: 
		[(self codeStream)
			nextPut: $$;
			nextPut: aValue.
		^self].
	(aValue isString or: [aValue isKindOf: LargePositiveInteger])
		ifTrue: 
			[self codeStream nextPutAll: aValue printString.
			^self].
	aValue storeOn: self codeStream</body>

<body package="GsToolsRefactoringBrowserExtensions">formatMultiLineCascadeMessage: aMessageNode
	selectorParts: selectorParts
	withArguments: formattedArgs
	
	self indentWhile: 
		[self codeStream
			nextPutAll: selectorParts first value;
			space;
			nextPutAllLines: formattedArgs first
				maxSize: self maxLineSize.
		2 
			to: formattedArgs size
			do: 
				[:i | 
				self codeStream crAndIndent.
				self codeStream
					nextPutAll: (selectorParts at: i) value;
					space;
					nextPutAllLines: (formattedArgs at: i)
						maxSize: self maxLineSize]]</body>

<body package="GsToolsRefactoringBrowserExtensions">findToken: separator
	inString: aString
	"Answer an OrderedCollection of the sub-sequences 
	of the receiver that are separated by separator."
	
	| str tokens |
	(aString includes: separator) 
		ifFalse: [^OrderedCollection with: aString].
	str := aString readStream.
	tokens := OrderedCollection new: 15.
	[str atEnd] 
		whileFalse: 
			[| token |
			token := str upTo: separator.
			token isEmpty 
				ifFalse: [tokens addLast: token]].
	(str
		skip: -1;
		next) = separator 
			ifTrue: [tokens addLast: (aString copyEmpty: 0)].
	^tokens</body>

<body package="GsToolsRefactoringBrowserExtensions">getSourceTextForNode: aNode 
	| methodNode |
	methodNode := aNode.
	
	[[methodNode parent notNil]
		whileTrue: [methodNode := methodNode parent].
	^methodNode source asString copyFrom: aNode start to: aNode stop]
		on: Error
		do: 
			[:err |
			^aNode value printString]</body>

<body package="GsToolsRefactoringBrowserExtensions">indentBy: indentNumber while: aBlock

	self codeStream indentBy: indentNumber while: aBlock</body>

<body package="GsToolsRefactoringBrowserExtensions">formatMethodSignature: aMethodNode 
	
	| selectorParts arguments sizeIfOnOneLine |
	selectorParts := aMethodNode selectorParts.
	arguments := aMethodNode arguments.
	arguments isEmpty 
		ifTrue: 
			[self codeStream nextPutAll: selectorParts first value.
			^self].
	sizeIfOnOneLine := 0.
	selectorParts do: [:each | sizeIfOnOneLine := sizeIfOnOneLine + each value size].
	arguments do: [:each | sizeIfOnOneLine := sizeIfOnOneLine + each name size + 2].
	sizeIfOnOneLine &lt;= self maxLineSize 
		ifTrue: 
			[selectorParts doWithIndex: 
				[:selector :index | 
				| arg |
				arg := arguments at: index.
				self codeStream nextPutAll: selector value.
				self codeStream space.
				self visitArgument: arg.
				self codeStream space].
			^self].
	selectorParts doWithIndex: 
		[:selector :index | 
		| arg |
		arg := arguments at: index.
		index = 1 
			ifTrue: 
				[self codeStream nextPutAll: selector value.
				self codeStream space.
				self visitArgument: arg]
			ifFalse: 
				[self indentWhile: 
					[self codeStream crAndIndent.
					self codeStream nextPutAll: selector value.
					self codeStream space.
					self visitArgument: arg]]]</body>

<body package="GsToolsRefactoringBrowserExtensions">formatLiteralNode: aNode
	
	| aValue |
	aValue := aNode value.
	(aValue class == Array) | (aValue class == ByteArray) ifTrue: 
		[^self formatLiteralArrayNode: aNode].
	aValue isSymbol ifTrue: 
		[self formatSymbol: aValue.
		^self].
	aValue class == Character ifTrue: 
		[(self codeStream)
			nextPut: $$;
			nextPut: aValue.
		^self].
	(aValue isString or: [aValue isKindOf: LargePositiveInteger])
		ifTrue: 
			[self codeStream nextPutAll: aValue printString.
			^self].
	aValue storeOn: self codeStream</body>

<body package="GsToolsRefactoringBrowserExtensions">formatStatementsFor: aSequenceNode
	
	| statements |
	statements := aSequenceNode statements.
	statements isEmpty ifTrue: [^self].
	self 
		for: statements
		do: 
			[:statement | 
			self visitNode: statement.
			statements last == statement ifFalse: [self codeStream nextPut: $.].
			self formatMethodCommentFor: statement]
		separatedBy: [self codeStream crAndIndent]</body>

<body package="GsToolsRefactoringBrowserExtensions">formatLiteralArrayNode: aNode

	self codeStream nextPutAll: (self getSourceTextForNode: aNode).</body>

<body package="GsToolsRefactoringBrowserExtensions">indentWhile: aBlock

	self codeStream indentWhile: aBlock</body>

<body package="GsToolsRefactoringBrowserExtensions">formatMessage: aMessageNode
	
	| selectorParts arguments formattedArgs |
	selectorParts := aMessageNode selectorParts.
	arguments := aMessageNode arguments.
	formattedArgs := OrderedCollection new.
	1 
		to: arguments size
		do: 
			[:i | 
			| string |
			string := self class new format: (arguments at: i).
			formattedArgs add: string].
	self 
		formatMessage: aMessageNode
		selectorParts: selectorParts
		withArguments: formattedArgs
		cascade: false</body>

<body package="GsToolsRefactoringBrowserExtensions">visitNode: aNode
	
	| parenthesis |
	parenthesis := self needsParenthesisFor: aNode.
	parenthesis ifTrue: [self codeStream nextPut: $(].
	aNode acceptVisitor: self.
	parenthesis ifTrue: [self codeStream nextPut: $)]</body>

<body package="GsToolsRefactoringBrowserExtensions">formatMessage: aMessageNode
	selectorParts: selectorParts
	withArguments: formattedArgs
	cascade: cascadeBoolean
	
	(self shouldStartMessageSendOnNewLine: aMessageNode withArguments: formattedArgs) 
		ifTrue: 
			[cascadeBoolean 
				ifTrue: 
					[self 
						formatMultiLineCascadeMessage: aMessageNode
						selectorParts: selectorParts
						withArguments: formattedArgs]
				ifFalse: 
					[self 
						formatMultiLineMessage: aMessageNode
						selectorParts: selectorParts
						withArguments: formattedArgs]]
		ifFalse: 
			[self 
				formatOneLineMessage: aMessageNode
				selectorParts: selectorParts
				withArguments: formattedArgs]</body>

<body package="GsToolsRefactoringBrowserExtensions">formatTagFor: aMethodNode
	
	| primitiveSources |
	primitiveSources := aMethodNode primitiveSources.
	primitiveSources do: 
		[:each | 
		self codeStream crAndIndent.
		self codeStream nextPutAll: each]</body>

<body package="GsToolsRefactoringBrowserExtensions">precedenceOf: parentSelector
	greaterThan: childSelector
	"Put parenthesis around things that are preceived to have 'lower' precedence. For example, 'a + b * c' 
	-&gt; '(a + b) * c' but 'a * b + c' -&gt; 'a * b + c'"
	
	| childIndex parentIndex operators |
	operators := #(#($| $&amp; $?) #($= $~ $&lt; $&gt;) #($- $+) #($* $/ $% $\) #($@)).
	childIndex := 0.
	parentIndex := 0.
	1 
		to: operators size
		do: 
			[:i | 
			((operators at: i) includes: parentSelector first) ifTrue: [parentIndex := i].
			((operators at: i) includes: childSelector first) ifTrue: [childIndex := i]].
	^childIndex &lt; parentIndex</body>

<body package="GsToolsRefactoringBrowserExtensions">formatCascadeMessage: aMessageNode
	
	| selectorParts arguments formattedArgs |
	selectorParts := aMessageNode selectorParts.
	arguments := aMessageNode arguments.
	formattedArgs := OrderedCollection new.
	1 
		to: arguments size
		do: 
			[:i | 
			| string |
			string := self class new format: (arguments at: i).
			formattedArgs add: string].
	self 
		formatMessage: aMessageNode
		selectorParts: selectorParts
		withArguments: formattedArgs
		cascade: true</body>

<body package="GsToolsRefactoringBrowserExtensions">formatTemporariesFor: aSequenceNode
	
	| temps |
	temps := aSequenceNode temporaries.
	temps isEmpty ifTrue: [^self].
	(self codeStream contents isNotEmpty and: [self codeStream contents last = $"])
		ifTrue: [self codeStream crAndIndent].
	self codeStream nextPutAll: '| '.
	temps do: 
		[:each | 
		self visitArgument: each.
		self codeStream nextPut: $ ].
	self codeStream nextPut: $|.
	self codeStream crAndIndent</body>

<body package="GsToolsRefactoringBrowserExtensions">formatMultiLineMessage: aMessageNode
	selectorParts: selectorParts
	withArguments: formattedArgs
	
	self indentWhile: 
		[1 
			to: formattedArgs size
			do: 
				[:i | 
				self codeStream crAndIndent.
				self codeStream
					nextPutAll: (selectorParts at: i) value;
					space;
					nextPutAllLines: (formattedArgs at: i)
						maxSize: self maxLineSize]]</body>

<body package="GsToolsRefactoringBrowserExtensions">tagBeforeTemporaries
	
	^Refactory.Browser.RBParser isVisualWorks</body>

<body package="GsToolsRefactoringBrowserExtensions">numberOfLeadingTabsIn: aString
	
	| stream number |
	stream := aString readStream.
	number := 0.
	[stream atEnd] 
		whileFalse: 
			[stream next = Character tab 
				ifTrue: [number := number + 1]
				ifFalse: [^number]].
	^number</body>

<body package="GsToolsRefactoringBrowserExtensions">formatOneLineMessage: aMessageNode
	selectorParts: selectorParts
	withArguments: formattedArgs
	
	formattedArgs isEmpty 
		ifTrue: 
			[self codeStream nextPutAll: selectorParts first value.
			^self].
	1 
		to: formattedArgs size
		do: 
			[:i | 
			i ~~ 1 
				ifTrue: [self codeStream space].
			self codeStream
				nextPutAll: (selectorParts at: i) value;
				space;
				nextPutAllLines: (formattedArgs at: i)
					maxSize: self maxLineSize]</body>

<body package="GsToolsRefactoringBrowserExtensions">formatMethodCommentFor: aNode
	
	| source lines |
	self shouldRemoveComments 
		ifTrue: [^self].
	source := aNode source.
	lines := 
		self 
			findToken: Character cr
			inString: self codeStream contents.
	source isNil 
		ifTrue: [^self].
	aNode comments do: 
		[:each | 
		(lines isEmpty or: [lines last trimBlanks isEmpty]) 
			ifFalse: [self codeStream crAndIndent].
		self codeStream nextPutAll: 
			(aNode source 
				copyFrom: each first
				to: each last)]</body>

<body package="GsToolsRefactoringBrowserExtensions">for: aValue
	do: doBlock
	separatedBy: separatorBlock
	
	aValue isEmpty ifTrue: [^self].
	1 
		to: aValue size - 1
		do: 
			[:i | 
			doBlock value: (aValue at: i).
			separatorBlock value].
	doBlock value: aValue last</body>

<body package="GsToolsRefactoringBrowserExtensions">shouldStartMessageSendOnNewLine: aMessageNode
	withArguments: formattedArgs
	
	| hasAnyMultiLineFormattedArgs |
	(self selectorsToStartOnNewLine includes: aMessageNode selector) 
		ifTrue: [^true].
	hasAnyMultiLineFormattedArgs := 
		(formattedArgs conform: 
			[:each | 
			(self 
				findToken: Character cr
				inString: each) size = 1]) not.
	((self selectorsToLeaveOnLine includes: aMessageNode selector) and: 
		[hasAnyMultiLineFormattedArgs not]) 
			ifTrue: [^false].
	^aMessageNode selector numArgs &gt; 1</body>

<body package="GsToolsRefactoringBrowserExtensions">needsParenthesisFor: aNode
	
	| parent grandparent |
	aNode isValue ifFalse: [^false].
	parent := aNode parent.
	parent isNil ifTrue: [^false].
	(aNode isMessage and: [parent isMessage and: [parent receiver == aNode]]) ifTrue: 
		[grandparent := parent parent.
		(grandparent notNil and: [grandparent isCascade and: [aNode isUnary not]]) ifTrue: [^true]].
	aNode precedence &lt; parent precedence ifTrue: [^false].
	aNode isAssignment &amp; parent isAssignment ifTrue: [^false].
	aNode isAssignment | aNode isCascade ifTrue: [^true].
	aNode precedence == 0 ifTrue: [^false].
	aNode isMessage ifFalse: [^true].
	aNode precedence = parent precedence ifFalse: [^true].
	aNode isUnary ifTrue: [^false].
	aNode isKeyword ifTrue: [^true].
	parent receiver == aNode ifFalse: [^true].
	^self 
		precedenceOf: parent selector
		greaterThan: aNode selector</body>
</methods>


<methods>
<class-id>Core.GsFormattedCodeStream</class-id> <category>utility</category>

<body package="GsToolsRefactoringBrowserExtensions">print: anObject

	self stream print: anObject</body>

<body package="GsToolsRefactoringBrowserExtensions">cr

	self stream cr.
	self tabs timesRepeat: [self stream tab].</body>

<body package="GsToolsRefactoringBrowserExtensions">nextPut: aChar

	self stream nextPut: aChar</body>

<body package="GsToolsRefactoringBrowserExtensions">findToken: separator
	inString: aString
	"Answer an OrderedCollection of the sub-sequences 
	of the receiver that are separated by separator."
	
	| str tokens |
	(aString includes: separator) 
		ifFalse: [^OrderedCollection with: aString].
	str := aString readStream.
	tokens := OrderedCollection new: 15.
	[str atEnd] 
		whileFalse: 
			[| token |
			token := str upTo: separator.
			token isEmpty 
				ifFalse: [tokens addLast: token]].
	(str
		skip: -1;
		next) = separator 
			ifTrue: [tokens addLast: (aString copyEmpty: 0)].
	^tokens</body>

<body package="GsToolsRefactoringBrowserExtensions">contents

	^self stream contents</body>

<body package="GsToolsRefactoringBrowserExtensions">crAndIndent

	self stream cr.
	self tabs timesRepeat: [self stream tab].</body>

<body package="GsToolsRefactoringBrowserExtensions">nextPutAll: aString

	self stream nextPutAll: aString</body>

<body package="GsToolsRefactoringBrowserExtensions">nextPutAllLines: aString
	maxSize: aNumber
	
	| lines shouldIndent lastLineSizeSoFar |
	lines := 
		self 
			findToken: Character cr
			inString: aString.
	lastLineSizeSoFar := (self contents tokensBasedOn: Character cr) last size.
	shouldIndent := lines size &gt; 1 or: [lines first size + lastLineSizeSoFar &gt; aNumber].
	shouldIndent 
		ifTrue: 
			[self indentWhile: 
				[lines do: 
					[:each | 
					self crAndIndent.
					self nextPutAll: each]]]
		ifFalse: [self nextPutAll: lines first]</body>

<body package="GsToolsRefactoringBrowserExtensions">indentWhile: aBlock
	
	self tabs: self tabs + 1.
	aBlock value.
	self tabs: self tabs - 1</body>

<body package="GsToolsRefactoringBrowserExtensions">indentBy: indentNumber while: aBlock
	
	self tabs: self tabs + indentNumber.
	aBlock value.
	self tabs: self tabs - indentNumber</body>

<body package="GsToolsRefactoringBrowserExtensions">space

	self stream nextPut: $ .</body>
</methods>

<methods>
<class-id>Core.GsFormattedCodeStream</class-id> <category>initialize-release</category>

<body package="GsToolsRefactoringBrowserExtensions">initialize

	self stream: (WriteStream on: String new).
	self tabs: 0.</body>
</methods>

<methods>
<class-id>Core.GsFormattedCodeStream</class-id> <category>printing</category>

<body package="GsToolsRefactoringBrowserExtensions">printOn: aStream

	aStream
		nextPutAll: self class name;
		nextPut: $(;
		cr;
		nextPutAll: self contents;
		nextPut: $).</body>
</methods>

<methods>
<class-id>Core.GsFormattedCodeStream</class-id> <category>accessing</category>

<body package="GsToolsRefactoringBrowserExtensions">stream
	^stream</body>

<body package="GsToolsRefactoringBrowserExtensions">stream: anObject
	stream := anObject</body>

<body package="GsToolsRefactoringBrowserExtensions">tabs
	^tabs</body>

<body package="GsToolsRefactoringBrowserExtensions">tabs: anObject
	tabs := anObject</body>
</methods>


<methods>
<class-id>Tools.SmalltalkWorkbench class</class-id> <category>browsing</category>

<body package="GsToolsRefactoringBrowserExtensions">browseClass: aClass
	
	| nm |
	SmalltalkWorkbench useRefactoringBrowser 
		ifTrue: [^Refactory.Browser.RefactoringBrowser newOnClass: aClass].
	nm := (UISettings preferenceFor: #browserType) asQualifiedReference.
	nm simpleName == #Browser 
		ifTrue: [^TabApplicationSystemBrowser openOnClass: aClass].
	nm simpleName == #HierarchyBrowser 
		ifTrue: [^TabApplicationSystemBrowser openOnClassHierarchy: aClass].
	^nm value newOnClass: aClass</body>

<body package="GsToolsRefactoringBrowserExtensions">useRefactoringBrowser

	[(((Smalltalk at: #Refactory) at: #Browser) at: #RefactoringBrowser) notNil]
		on: Error
		do: [:err | ^false].
	^true</body>
</methods>


<methods>
<class-id>Core.GsFormattedCodeStream class</class-id> <category>instance creation</category>

<body package="GsToolsRefactoringBrowserExtensions">new

	^super new
		initialize;
		yourself</body>
</methods>



<initialize>
<class-id>Root.Smalltalk.Core.GsFormatter</class-id>
</initialize>

</st-source>

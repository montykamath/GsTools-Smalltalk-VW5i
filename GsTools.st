<?xml version="1.0"?>

<st-source>
<time-stamp>From VisualWorks®, Release 5i.4 of August 9, 2001 on March 29, 2002 at 6:18:35 am</time-stamp>
<!-- Package GsTools(3.2.2,sourcecontrol) -->


<do-it>( Store.Registry packageNamedOrCreate: 'GsTools' ) 
	prerequisiteParcels: #(#('ColorEditing' '5i4') #('Method-History' '5i4'));
	postLoadBlock: '[ :pkg |  
GsTools setBrowserTextColors.
Win95WidgetPolicy initializeDefaultGenericColors.
]';
	developmentPrerequisites: #(#(#any 'ColorEditing' '5i4') #(#any 'Method-History' '5i4'));
	yourself.</do-it>



<class>
<name>GsTools</name>
<environment>Smalltalk</environment>
<super>Core.Object</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars></inst-vars>
<class-inst-vars>StoreStreamVersion </class-inst-vars>
<imports>
			Graphics.TextConstants.*
			</imports>
<category>GsTools</category>
<attributes>
<package>GsTools</package>
</attributes>
</class>

<class>
<name>GstObject</name>
<environment>Smalltalk</environment>
<super>Core.Object</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars></inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>GsTools</category>
<attributes>
<package>GsTools</package>
</attributes>
</class>

<class>
<name>GstMethodGenerator</name>
<environment>Smalltalk</environment>
<super>GstObject</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars></inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>GsTools</category>
<attributes>
<package>GsTools</package>
</attributes>
</class>





<methods>
<class-id>UI.Win95WidgetPolicy class</class-id> <category>private-initializing</category>

<body package="GsTools">initializeDefaultGenericColors
	"self initializeDefaultGenericColors"

	| dgray hgray |

	dgray := ColorValue brightness: 128 / 255.
	hgray := ColorValue brightness: 192 / 255.
	self allPreferencesDo: [:preferences |
		preferences
			matchAt: SymbolicPaint border put: ColorValue black;
			matchAt: SymbolicPaint foreground put: ColorValue black;
			matchAt: SymbolicPaint background put: hgray;
			matchAt: SymbolicPaint selectionForeground put: ColorValue white;
			matchAt: SymbolicPaint selectionBackground put: ColorValue black;
			matchAt: SymbolicPaint hilite put: ColorValue white;
			matchAt: SymbolicPaint shadow put: dgray;
			matchAt: SymbolicPaint separator put: ColorValue black;
			matchAt: SymbolicPaint inactiveBackground put: hgray;
			matchAt: SymbolicPaint inactiveForeground put: dgray;
			matchAt: SymbolicPaint inactiveSelectionBackground put: dgray;
			matchAt: SymbolicPaint inactiveSelectionForeground put: hgray;
			matchAt: SymbolicPaint traversalHilite put: self lookPolicyClass traversalHilitePattern].
	self defaultColorWidgetColors
			matchAt: SymbolicPaint selectionBackground put: ColorValue gray</body>
</methods>


<methods>
<class-id>Core.String</class-id> <category>Camp Smalltalk</category>

<body package="GsTools">gstSubStrings
	| stream answer index |
	answer := OrderedCollection new.
	stream := ReadStream on: self.
	[stream atEnd]
		whileFalse: 
			[[stream atEnd ifTrue: [^answer asArray].
			stream peek &gt; (Core.TextConstants.Space)]
				whileFalse: [stream next].
			index := stream position + 1.
			[stream atEnd or: [stream peek &lt;= (Core.TextConstants.Space)]]
				whileFalse: [stream next].
			answer add: (self copyFrom: index to: stream position)].
	^answer asArray</body>
</methods>

<methods>
<class-id>Core.String</class-id> <category>converting</category>

<body package="GsTools">gsBindWith: aString1 with: aString2 with: aString3 with: aString4

	^self gsBindWithArguments: (
		OrderedCollection new
			add: aString1;
			add: aString2;
			add: aString3;
			add: aString4;
			yourself)</body>

<body package="GsTools">gsBindWithArguments: anArray 
	"
	'one: %1 two: %2 ten: %10' bindWithArguments: #('a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'k') 
	"
	| stream answer |
	stream := self readStream.
	answer := WriteStream on: (self species new: self size).
	[stream atEnd] 	whileFalse: 
		[| string |
		string := stream upTo: $%.
		answer nextPutAll: string.
		stream atEnd ifFalse: 
			[| int |
			int := Number readFrom: stream.
			(int &gt; anArray size or: [int &lt; 1])
				ifTrue: [answer nextPutAll: '%', int printString]
				ifFalse: [answer nextPutAll: (anArray at: int)]]].
	^answer contents</body>

<body package="GsTools">gsBindWith: aString1 with: aString2 with: aString3 with: aString4 with: aString5

	^self gsBindWithArguments: (
		OrderedCollection new
			add: aString1;
			add: aString2;
			add: aString3;
			add: aString4;
			add: aString5;
			yourself)</body>

<body package="GsTools">gsBindWith: aString1 with: aString2 with: aString3

	^self gsBindWithArguments: (
		OrderedCollection new
			add: aString1;
			add: aString2;
			add: aString3;
			yourself)</body>

<body package="GsTools">gsBindWith: aString1 with: aString2

	^self gsBindWithArguments: (
		OrderedCollection new
			add: aString1;
			add: aString2;
			yourself)</body>

<body package="GsTools">gsBindWith: aString1

	^self gsBindWithArguments: (
		OrderedCollection new
			add: aString1;
			yourself)</body>
</methods>

<methods>
<class-id>Core.String</class-id> <category>accessing</category>

<body package="GsTools">gstTrimBlanks

	| size index space |
	(size := self size) == 0 ifTrue: [^self].
	index := 1.
	space := Character space.
	[(self at: index) = space] whileTrue: [
		index = size ifTrue: [^''].
		index := index + 1].
	[(self at: size) = space] whileTrue: [
		index = size ifTrue: [^''].
		size := size - 1].
	^self copyFrom: index to: size</body>
</methods>


<methods>
<class-id>Graphics.DispatchTable</class-id> <category>accessing</category>

<body package="GsTools">bindValue: aValue to: aCharacter modifiers: metaCollection
	"Arrange for aValue to be answered whenever aCharacter is passed in
	with the same set of meta state bits defined in metaCollection."

	| array index |
	self forkCopy.
	(composeTable includesKey: aCharacter)
		ifTrue:	[self notify: (#errBindMetaCharacter &lt;&lt; #dialogs &gt;&gt; 'This character is a meta-character.  Proceed to rebind it').
				composeTable removeKey: aCharacter].
	array := baseTable at: aCharacter ifAbsent: [nil].
	array class == Array
		ifTrue:	[array := array copy]
		ifFalse:	[array := Array new: 16 withAll: array].
	index := 0.
	"NO meta check because keys came in with alt &amp; meta"
	(metaCollection includes: #shift) ifTrue: [index := index bitOr: InputState shiftMask].
	(metaCollection includes: #control) ifTrue: [index := index bitOr: InputState ctrlMask].
	(metaCollection includes: #meta) ifTrue: [index := index bitOr: InputState metaMask].
	(metaCollection includes: #alt) ifTrue: [index := index bitOr: InputState altMask].
	array at: index+1 put: aValue.
	baseTable at: aCharacter put: array</body>
</methods>

<methods>
<class-id>Graphics.DispatchTable</class-id> <category>private</category>

<body package="GsTools">lookup: anEntity meta: inputMetaState
	"anEntity is an object that should be mapped; answer the appropriate value"

	| table metaState |

	"Get the index the same way we set the index in #bindValue:to:modifiers:.
	NO meta check because keys came in with alt &amp; meta"
	metaState := 0.
	(inputMetaState anyMask: InputState shiftMask) ifTrue: [metaState := metaState bitOr: InputState shiftMask].
	(inputMetaState anyMask: InputState ctrlMask) ifTrue: [metaState := metaState bitOr: InputState ctrlMask].
	(inputMetaState anyMask: InputState metaMask) ifTrue: [metaState := metaState bitOr: InputState metaMask].
	(inputMetaState anyMask: InputState altMask) ifTrue: [metaState := metaState bitOr: InputState altMask].
	metaState := metaState + 1.

	table := baseTable at: anEntity ifAbsent: [nil].
	^(table == nil or: [table class == Array and: [(table at: metaState) == nil]])
		ifTrue:	[(anEntity isKindOf: Character)
					ifTrue:	[defaultForCharacters]
					ifFalse:	[defaultForNonCharacters]]
		ifFalse:	[table class == Array
					ifTrue:	[table at: metaState]
					ifFalse:	[table]]</body>
</methods>


<methods>
<class-id>UI.DefaultFeelPolicy</class-id> <category>initialize</category>

<body package="GsTools">initialize
	self keyboardDispatchTable.
	GsTools newSetupShortcutsForKeyboard: self keyboard</body>
</methods>


<methods>
<class-id>Tools.ClassesBrowserHelper class</class-id> <category>resources</category>

<body package="GsTools">listMenu
	"MenuEditor new openOnClass: self andSelector: #listMenu"

	&lt;resource: #menu&gt;
	^#(#{UI.Menu} #(
			#(#{UI.MenuItem} 
				#rawLabel: 'File out as...' 
				#nameKey: #fileOut 
				#value: #fileOut ) 
			#(#{UI.MenuItem} 
				#rawLabel: 'Hardcopy' 
				#nameKey: #hardcopy 
				#value: #hardcopy ) 
			#(#{UI.MenuItem} 
				#rawLabel: 'Spawn' 
				#nameKey: #spawn 
				#value: #spawn ) 
			#(#{UI.MenuItem} 
				#rawLabel: 'Spawn hierarchy' 
				#nameKey: #spawnHierarchy 
				#value: #spawnHierarchy ) 
			#(#{UI.MenuItem} 
				#rawLabel: 'Add class' 
				#nameKey: #add 
				#value: #addClassVariableSize 
				#submenu: #(#{UI.Menu} #(
						#(#{UI.MenuItem} 
							#rawLabel: 'Fixed size' 
							#nameKey: #addClassFixedSize 
							#value: #addClassFixedSize ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'Variable' 
							#nameKey: #addClassVariableSize 
							#value: #addClassVariableSize ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'Bytes' 
							#nameKey: #addClassBytes 
							#value: #addClassBytes ) ) #(3 ) nil ) ) 
			#(#{UI.MenuItem} 
				#rawLabel: 'Browse...' 
				#nameKey: #browse 
				#submenu: #(#{UI.Menu} #(
						#(#{UI.MenuItem} 
							#rawLabel: 'Inst var refs...' 
							#nameKey: #browseFieldReferences 
							#value: #browseFieldReferences ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'Class var refs...' 
							#nameKey: #browseClassVariables 
							#value: #browseClassVariables ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'Class refs' 
							#nameKey: #browseClass 
							#value: #browseClassReferences ) ) #(1 2 ) nil ) ) 
			#(#{UI.MenuItem} 
				#rawLabel: 'Move to...' 
				#nameKey: #move 
				#value: #move 
				#submenu: #(#{UI.Menu} #(
						#(#{UI.MenuItem} 
							#rawLabel: 'New category...' 
							#nameKey: #move 
							#value: #move ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'New environment...' 
							#nameKey: #moveNameSpace 
							#value: #moveNameSpace ) 
						#(#{UI.MenuItem} 
							#rawLabel: 'New parcel...' 
							#nameKey: #moveNewParcel 
							#value: #moveNewParcel ) ) #(3 ) nil ) ) 
			#(#{UI.MenuItem} 
				#rawLabel: 'Rename as...' 
				#nameKey: #rename 
				#value: #rename ) 
			#(#{UI.MenuItem} 
				#rawLabel: 'Remove...' 
				#nameKey: #remove 
				#value: #remove ) 
			#(#{UI.MenuItem} 
				#rawLabel: 'Generate Methods...' 
				#nameKey: #generateMethods 
				#value: #generateMethods ) ) #(4 2 4 ) nil ) decodeAsLiteralArray</body>
</methods>


<methods>
<class-id>Tools.VisualLauncher</class-id> <category>GSTOOLS</category>

<body package="GsTools">toolsGsTools

	&lt;submenu: 'GsTools'
		nameKey: #gstools
		menu: #(#menuBar #tools)
		position: 11.027&gt;

	^self</body>

<body package="GsTools">toolsGsToolsSetStoreStream

	&lt;menuItem: 'Set STORE Stream...'
		nameKey: #utility
		menu: #(#menuBar #tools #gstools)
		position: 1.05&gt;

	| version |
	((Smalltalk includesKey: #GsTools) and: [(Smalltalk at: #GsTools) class includesSelector: #storeStreamVersion])
		ifTrue: [
			version := Dialog request: 'Enter STORE stream version (e.g., 3.1):' initialAnswer: GsTools storeStreamVersion.
			version isNil
				ifTrue: [^self].

			version := version trimBlanks.
			GsTools storeStreamVersion: version]
		ifFalse: [Dialog warn: 'Latest version of GsTools must be loaded...']</body>
</methods>

<methods>
<class-id>Tools.VisualLauncher</class-id> <category>store menus</category>

<body package="GsTools">openRecentPublishedItems
	&lt;menuItem: '&amp;More Recent Published Items'
		icon: nil
		nameKey: nil
		enablement: #areAttached
		indication: nil
		menu: #(#menuBar #store)
		position: 20.03&gt;

	| list list2 |
	DbRegistry doIfOnlineImage: [
		| version |
		version := ((Smalltalk includesKey: #GsTools) and: [(Smalltalk at: #GsTools) class includesSelector: #storeStreamVersion])
			ifTrue: [GsTools storeStreamVersion]
			ifFalse: ['*'].
		list := ((Registry allPackagesWithNewerInDB select: [:each | version match: each version]) collect: [ :pkg | pkg name ]) asSet.
		list2  := ((Registry allBundlesWithNewerInDB select: [:each | version match: each version]) collect: [ :bundle | bundle name ]) asSet.
		Store.PublishedPundlesTool openOnBundles: list2 packages: list  
		]</body>
</methods>


<methods>
<class-id>GstObject</class-id> <category>initializing</category>

<body package="GsTools">initialize</body>
</methods>


<methods>
<class-id>GstMethodGenerator class</class-id> <category>actions</category>

<body package="GsTools">generateMethodsForClass: aClass

	| instVars myClass |

	(aClass isKindOf: Store.PseudoRecord) 
		ifTrue:
			[aClass isMeta
				ifTrue:[myClass := aClass instanceBehavior class]
				ifFalse:[myClass := aClass instanceBehavior]]
		ifFalse:[myClass := aClass].

	instVars := 
		SimpleDialog new
			chooseMultiple: 'Which ones do you want?'
			fromList: myClass instVarNames
			values: myClass instVarNames
			buttons: #() 
			values: #()
			lines: 8
			cancel: [#noChoice]
			for: Dialog defaultParentWindow.

	instVars == #noChoice ifTrue:[^nil].
	instVars do:
		[:each | 
		myClass compile:  (self getterTemplate gsBindWith: each) classified: 'accessing'.
		myClass compile:  (self setterTemplate gsBindWith: each) classified: 'accessing'.]</body>
</methods>

<methods>
<class-id>GstMethodGenerator class</class-id> <category>templates</category>

<body package="GsTools">setterTemplate
	^
'%1: anObject

	%1 := anObject'</body>

<body package="GsTools">getterTemplate
	^
'%1

	^%1'</body>
</methods>


<methods>
<class-id>Tools.Trippy.InspectorShell</class-id> <category>initialize-release</category>

<body package="GsTools">initialize

	super initialize.
	current := 0.
	evaluationPaneVisible := true.
	textHolder := SharedTextHolder.
	menuBarHolder := ValueHolder with: nil</body>
</methods>


<methods>
<class-id>UI.ParagraphEditor</class-id> <category>menu messages</category>

<body package="GsTools">accept
	"Save the current text of the text being edited as the current acceptable
	version for purposes of canceling."

	self gstUnboldTextKey: nil.
	self textHasChanged: false.
	model value: self text copy</body>
</methods>

<methods>
<class-id>UI.ParagraphEditor</class-id> <category>GS TOOLS</category>

<body package="GsTools">gsComputeCurrentCompletionPrefix

	| stop str start prefix |
	stop := self selectionStartIndex.
	stop = self selectionStartIndex ifFalse: [^''].
	stop &gt; 1 ifFalse: [^''].
	str := self text asString.
	(stop &lt;= str size and: [(str at: stop) isAlphaNumeric or: [(str at: stop)
				= $:]])
		ifTrue: [^''].
	start := stop - 1.
	[start &gt; 0 and: [(str at: start) isAlphaNumeric]]
		whileTrue: [start := start - 1].
	prefix := str copyFrom: start + 1 to: stop - 1.
	prefix detect: [:char | char isAlphabetic]
		ifNone: [^''].
	^prefix</body>

<body package="GsTools">gstBrowseSendersKey: aCharEvent 
	"Replace the current text selection by the text in the shared buffer."

	| selectedText trial mc coll symbol |
	selectedText := self selection asString gstTrimBlanks.
	selectedText isEmpty ifTrue: [^SmalltalkWorkbench promptThenBrowseCallsFrom: nil].
	trial := selectedText.
	mc := MethodCollector new.
	((trial includes: $*) or: [trial includes: $#])
		ifTrue:		"pattern"
			[coll := OrderedCollection new.
			Cursor wait showWhile:
				[Symbol allSubInstancesDo: 
					[:sym | (trial match: sym ) ifTrue: [coll add: sym]]].
			mc interfaceWindow: nil.
			symbol := mc showMenu: coll prompt: 'Find all references to...'.
			symbol == nil ifFalse: [mc browseSelect: (mc referencesTo: symbol)]]
		ifFalse:	"single item"
			[symbol := Symbol findInterned: trial.
			symbol isNil ifTrue:
				[| correction |
				"It doesn't exist, therefore no senders. Try and correct"
				correction := Symbol correctMessage: trial minimumScore: 100.
				correction isEmpty 
					ifTrue:
						[trial := trial, '*'.
						coll := OrderedCollection new.
						Cursor wait showWhile:
							[Symbol allSubInstancesDo: 
								[:sym | (trial match: sym ) ifTrue: [coll add: sym]]].
						mc interfaceWindow: nil.
						symbol := mc showMenu: coll prompt: 'Find all references to...'.
						symbol == nil ifFalse: [mc browseSelect: (mc referencesTo: symbol)].
						^self].
				symbol := correction first key.
				(Dialog confirm: ('There is no such selector as ', trial, '\Do you want to browse ', symbol, ' instead?') withCRs) ifFalse:
					[^self]].
			mc browseSelect: (mc referencesTo: symbol)]</body>

<body package="GsTools">gstIndentKey: aKey

	| string here before start stop inStream outStream after count |
	self selection isEmpty
		ifTrue: [^self].

	string := self text string.
	here := self selectionStartIndex.
	before := (string copyFrom: 1 to: here - 1) reverse readStream.
	before skipUpTo: Character cr.
	after := (string copyFrom: self selectionStopIndex to: string size) readStream.
	after skipUpTo: Character cr.

	start := here - before position.
	stop := self selectionStopIndex + after position - 1.
	inStream := (string copyFrom: start to: stop) readStream.
	outStream := (String new: 100) writeStream.
	count := 1.
	outStream tab.
	[inStream atEnd] whileFalse: [
		| next |
		next := inStream next.
		outStream nextPut: next.
		next = Character cr
			ifTrue: [
				inStream peek = Character lf
					ifTrue: [inStream next].
				count := count + 1.
				outStream tab]].

	self
		selectFrom: start to: stop;
		replaceFrom: start to: stop with: outStream contents asText;
		selectFrom: start to: stop + count</body>

<body package="GsTools">gstCompleteMethodFor: prefix

	| coll answer |
	coll := OrderedCollection new.
	SmalltalkWorkbench allImplementedMessages do: 
		[:sym | (prefix,'*' match: sym) ifTrue: [coll add: sym]].
	coll isEmpty ifTrue: [^nil].
	coll := coll asSortedCollection asArray.
	answer :=
		coll size = 1 
			ifTrue: [coll first]
			ifFalse:
				[Dialog 
					choose: 'Which one do you want?' 
					fromList: coll
					values: coll
					lines: 10
					cancel: [nil]].
	answer isNil ifTrue: [^nil].
	self appendToSelection: (answer copyFrom: prefix size + 1 to: answer size)</body>

<body package="GsTools">gstCompleteGlobalFor: prefix

	| coll answer |
	coll := OrderedCollection new.
	Root withAllNameSpacesAndAllClassesAndStatics do:
		[:ref | (prefix,'*' match: ref name) ifTrue: [coll add: ref name]].
	coll isEmpty ifTrue: [^nil].
	answer :=
		coll size = 1 
			ifTrue: [coll first]
			ifFalse:
				[Dialog 
					choose: 'Which one do you want?' 
					fromList: coll
					values: coll
					lines: 10
					cancel: [nil]].
	answer isNil ifTrue: [^nil].
	self appendToSelection: (answer copyFrom: prefix size + 1 to: answer size)</body>

<body package="GsTools">gstSwitchToWindow: ignored

	| col answer |
	col := OrderedCollection new.
	ScheduledControllers scheduledControllers 
		do: [:c | 	
		[col add: c view label asString -&gt; c view]
			on: Object errorSignal 
			do: [:ex | ex return]].
	col := col asSortedCollection: [:a1 :a2 | a1 key &lt;= a2 key].

	answer :=
		Dialog 
			choose: 'Which one do you want?' 
			fromList: (col collect: [:e | e key])
			values: (col collect: [:e | e value])
			lines: (col size min: 10)
			cancel: [nil].
	answer isNil ifTrue: [^nil].
	answer isCollapsed
		ifTrue: [answer expand]
		ifFalse: [answer raise]</body>

<body package="GsTools">gstDebugKey: key

	| start stop |
	self selectLine.
	start := self selectionStartIndex.
	stop := self selectionStopIndex.
	start = stop ifTrue: [^nil].
	self insertAndSelect: 'self halt.
' at: start.
	self deselect.
	self selectFrom: start to: stop + 11.
	self doIt.</body>

<body package="GsTools">gstBrowseImplementorsKey: aCharEvent
	"Replace the current text selection by the text in the shared buffer."

	| selectedText trial coll mc sel |
	selectedText := self selection asString gstTrimBlanks.
	selectedText isEmpty ifTrue:[^SmalltalkWorkbench promptThenBrowseImplementorsFrom: nil].
	trial := selectedText.

	coll := OrderedCollection new.
	Cursor wait showWhile:
		[SmalltalkWorkbench allImplementedMessages do: 
			[:sym | (trial match: sym) ifTrue: [coll add: sym]]].

	mc := MethodCollector new.
	mc interfaceWindow: nil.
	coll size = 1 ifTrue: [^mc browseSelect: (mc implementorsOf: coll first)].

	coll isEmpty
		ifTrue: 
			[trial := trial, '*'.
			SmalltalkWorkbench allImplementedMessages do: 
				[:sym | (trial match: sym) ifTrue: [coll add: sym]]].
	coll isEmpty
		ifTrue: [^Dialog warn: 'No matching messages' for: nil].

	sel := mc
		showMenu: coll asSortedCollection
		prompt: 'Find all implementors of...'.
	sel == nil ifTrue: [^self].
	mc browseSelect: (mc implementorsOf: sel)</body>

<body package="GsTools">gstCompleteKey: aKey

	| prefix |
	prefix := self gsComputeCurrentCompletionPrefix trimBlanks.
	(prefix isNil or: [prefix isEmpty]) ifTrue: [^nil].
	prefix first isUppercase
		ifTrue: [self gstCompleteGlobalFor: prefix]
		ifFalse: [self gstCompleteMethodFor: prefix]</body>
</methods>

<methods>
<class-id>UI.ParagraphEditor</class-id> <category>editing</category>

<body package="GsTools">gstDeleteKey: aCharEvent
	| stopIndex |

	self notePossibleBeginingOfTypeIn.
	self selectionStartIndex &lt; self selectionStopIndex
		ifTrue: [self replaceSelectionWith: Text new]
		ifFalse: 
			[stopIndex := self selectionStopIndex + 1.
			self selectionStopIndex: stopIndex.
			self beginTypeInIndex: (self beginTypeInIndex min: stopIndex).
			self replaceSelectionWith: Text new]</body>

<body package="GsTools">gstPrintItKey: aKey

	self
		selectLine;
		printIt</body>

<body package="GsTools">gstInspectKey: aKey

	self
		selectLine;
		inspectIt</body>

<body package="GsTools">gstDoItKey: aKey

	self
		selectLine;
		doIt</body>

<body package="GsTools">gstBrowseKey: aCharEvent
	"Replace the current text selection by the text in the shared buffer."

	| selectedClass selectedText |
	selectedText := self selection asString gstTrimBlanks.
	selectedText isEmpty 
		ifTrue:[^SmalltalkWorkbench chooseAndBrowseClassFrom: nil].
	selectedClass := Root allClasses detect:[:cls | selectedText = cls name asString] ifNone:[nil].
	selectedClass isNil ifFalse:[^selectedClass browse].

	self gstBrowseImplementorsKey: aCharEvent.</body>

<body package="GsTools">selectLine
	"Select the line the cursor is on if there is no selection."

	| string here after before |
	self selection isEmpty
		ifFalse: [^self].

	string := self text string.
	here := self selectionStartIndex.
	after := (string copyFrom: here to: string size) readStream.
	before := (string copyFrom: 1 to: here - 1) reverse readStream.

	before skipUpTo: Character cr.
	after skipUpTo: Character cr.
	self selectFrom: here - before position to: here + after position - 1.</body>

<body package="GsTools">gstPasteKey: aKey

	| stop |
	self gstPaste.
	stop := self selectionStopIndex.
	self selectAt: stop.</body>

<body package="GsTools">gstTypeArgument: key

	| args index argIndex |

	index := 0.
	args := (ReadStream on: self paragraph text) gstNextLine asString gstSubStrings select:
		[ :each | index := index + 1.
		index even ].
	(argIndex := key keyCharacter digitValue) &lt;= args size ifTrue:
		[ self appendToSelection: (args at: argIndex) ]</body>

<body package="GsTools">gstOutdentKey: aKey

	| string here before start stop inStream outStream after count |
	self selection isEmpty
		ifTrue: [^self].

	string := self text string.
	here := self selectionStartIndex.
	before := (string copyFrom: 1 to: here - 1) reverse readStream.
	before upTo: Character cr.
	after := (string copyFrom: self selectionStopIndex to: string size) readStream.
	after skipUpTo: Character cr.

	start := here - before position.
	stop := self selectionStopIndex + after position - 1.
	inStream := (string copyFrom: start to: stop) readStream.
	outStream := (String new: 100) writeStream.
	count := 0.

	(start = 1 and: [inStream peek = Character tab])
		ifTrue: [inStream next].

	[inStream atEnd] whileFalse: [
		| next |
		next := inStream next.
		outStream nextPut: next.
		next = Character cr
			ifTrue: [
				inStream peek = Character lf
					ifTrue: [inStream next].
				inStream peek = Character tab
					ifTrue: [
						count := count + 1.
						inStream next]]].

	self
		selectFrom: 1 to: 1;
		replaceFrom: start to: stop with: outStream contents asText.

	start = 1
		ifTrue: [start := 0].

	self selectFrom: start + 1 to: stop - count - 1</body>

<body package="GsTools">gstPaste
	"Paste the text from the shared buffer over the current selection and redisplay 
	if necessary. If the shift key is down, present the user with a menu of
	the last few selections."

	| textToPaste |
	textToPaste := self currentSelection.
	self currentSelection: self selection.  "add the text being removed to the stack"
	self currentSelection: textToPaste.	"add the text being pasted to the stack"
	self performPasteAction: textToPaste	"so subclasses can do other paste-like actions"</body>

<body package="GsTools">gstExtendedPasteKey: aKey

	self gstExtendedPaste</body>

<body package="GsTools">gstExtendedPaste
	"Paste the text from the shared buffer over the current selection and redisplay 
	if necessary. If the shift key is down, present the user with a menu of
	the last few selections."

	| prev textToPaste |
	prev := self previousSelections.
	textToPaste := Dialog choose: 'Pick a selection'
				fromList: (prev collect:
						[:aText | (aText string contractTo: 40)
							collect: [:char | char isSeparator
									ifTrue: [Character space]
									ifFalse: [char]]])
				values: prev
				lines: 10
				cancel: [^self]
				for: view.
	self currentSelection: textToPaste.
	self gstPaste.</body>

<body package="GsTools">gstUnboldTextKey: aCharEvent 
	| startIndex stopIndex |
	startIndex := self selectionStartIndex.
	stopIndex := self selectionStopIndex - 1.
	self selectAllKey: aCharEvent.
	self replaceSelectionWith: self text asString.
	self
		selectFrom: startIndex to: stopIndex;
		setEmphasisHere</body>

<body package="GsTools">gstBackspaceKey: aCharEvent
	"Backspace over the last character--i.e., cut the previous character."

	| startIndex |
	self notePossibleBeginingOfTypeIn.
	self selectionStartIndex &lt; self selectionStopIndex
		ifTrue: [self replaceSelectionWith: Text new.]
		ifFalse: 
			[startIndex := 1 max: self selectionStartIndex - 1.
			self selectionStartIndex: startIndex.
			self beginTypeInIndex: (self beginTypeInIndex min: startIndex).
			self replaceSelectionWith: Text new]</body>
</methods>


<methods>
<class-id>UI.MotifFeelPolicy</class-id> <category>initialize</category>

<body package="GsTools">initialize
	self keyboardDispatchTable.
	GsTools newSetupShortcutsForKeyboard: self keyboard.
	self addMotifKeys</body>
</methods>


<methods>
<class-id>UI.Win95FeelPolicy</class-id> <category>initialize</category>

<body package="GsTools">initialize
	self keyboardDispatchTable.
	GsTools newSetupShortcutsForKeyboard: self keyboard</body>
</methods>


<methods>
<class-id>GstObject class</class-id> <category>creation</category>

<body package="GsTools">new
	^super new initialize</body>
</methods>


<methods>
<class-id>Kernel.GeneralNameSpace</class-id> <category>private</category>

<body package="GsTools">conflictingImports: key firstFound: bind

	true ifTrue: [^self].

	"This is what it used to do"
	Warning new
		errorString: ('Duplicate bindings have been found for "&lt;1s&gt;" from &lt;2s&gt;'
			expandMacrosWith: key
			with: self namedReferent fullName);
		parameter: bind;
		raiseSignal</body>
</methods>


<methods>
<class-id>UI.Win95MenuBarButtonView</class-id> <category>privileged</category>

<body package="GsTools">processShortcutKeyEventAsMenuBarAccessor: aKeyboardEvent
	"Disable menu shortcuts"

	^false</body>
</methods>


<methods>
<class-id>Core.PositionableStream</class-id> <category>accessing</category>

<body package="GsTools">gstNextLine
	"Answer next line (may be empty), or nil if at end"

	self atEnd ifTrue: [^nil].
	^self upTo: Character cr</body>
</methods>


<methods>
<class-id>UI.MacFeelPolicy</class-id> <category>initialize</category>

<body package="GsTools">initialize
	self keyboardDispatchTable.
	GsTools newSetupShortcutsForKeyboard: self keyboard</body>
</methods>


<methods>
<class-id>Tools.MethodsBrowserHelper</class-id> <category>menus accessing</category>

<body package="GsTools">actionsForMultiSelect

	^#(#copyMethodsToAnotherClass #fileOut #hardcopy #spawn  #remove)</body>

<body package="GsTools">copyMethodsToAnotherClass
	&lt;menuItem: 'Copy To Class...'
		icon: nil
		nameKey: #copyMethodsToAnotherClass
		menu: #(#listMenu)
		position: 90.01&gt;

	| toBeCopied newClass newClassName |
	newClassName := Dialog request: 'Enter the new class name'.
	newClassName isNil ifTrue: [^nil].
	[newClass := Compiler evaluate: newClassName] 
		on: Error 
		do: [:exception | ^nil].
	newClass isNil ifTrue: [^nil].
	toBeCopied := module selections collect: 
		[:slctn | self definitionOf: slctn ].
	
	toBeCopied do: [:eachMethod |
		newClass 
			compile: eachMethod sourceCode 
			classified: (self targetClass organization categoryOfItem:  eachMethod selector)
			notifying: nil]</body>
</methods>


<methods>
<class-id>Tools.ClassesBrowserHelper</class-id> <category>menus accessing</category>

<body package="GsTools">actionsForClassesOnly

	^#(#browseFieldReferences #browseClassVariables #instVarAssign #instVarRead #addClassProbesMenu #removeClassProbesMenu #browseProbedMethods #generateMethods)</body>

<body package="GsTools">generateMethods

	GstMethodGenerator generateMethodsForClass: self selectedItem.</body>
</methods>


<methods>
<class-id>UI.ScheduledWindow</class-id> <category>private</category>

<body package="GsTools">defaultRectangle: extent 
	"Answer a default rectangle in which to place the receiver."

	| r bounds |
	PromptForOpen
		ifTrue: 
			[r := Rectangle
						originFromUser: extent
						grid: (1 @ 1)
						whileButton: 0
						isDown: false.
			"the resizing primitive will fail if no completely visible
			rectangle can meet the minimumSize constraint, so
			alter the rectangle in that case"
			bounds := Screen default preferredRectangleToConstrain: r.
			r bottomRight: (r bottomRight min: bounds bottomRight).
			r width &lt; self minimumSize x
				ifTrue: [r left: r right - self minimumSize x].
			r height &lt; self minimumSize y
				ifTrue: [r top: r bottom - self minimumSize y].
			(bounds contains: r)
				ifTrue:
					[r := Screen default
							resizeRectangle: r
							minimumExtent: self minimumSize
							resizeIncrement: (1 @ 1)
							boundedBy: ((r origin + self minimumSize) corner: Screen default bounds extent)
							whileButton: 0
							isDown: true.
					r extent: (self maximumSize min: r extent)]]
		ifFalse: [
			| oldOrigin newOrigin currentController newExtent |
			currentController := ScheduledControllers activeController.
			newExtent := currentController model class == self model class
				ifTrue: [currentController view extent]
				ifFalse: [extent].
			(currentController model isKindOf: Debugger) 
				ifTrue: [newExtent := extent].

			oldOrigin := currentController view globalOrigin.
			newOrigin := oldOrigin + (35 @ 35).
			newOrigin := (newOrigin x + newExtent x &gt; Screen default bounds right) | (newOrigin y + newExtent y &gt; Screen default bounds bottom)
				ifTrue: [Screen default bounds topLeft + (150 @ 75)]
				ifFalse: [newOrigin].


			r := newOrigin  extent: newExtent.
			
			"leave some headroom at the top left corner to ensure that at
			least some part of the title bar decoration is visible and accessible;
			we don't do this in the PromptForOpen case because the
			user then has full control over placement"
			bounds := (Screen default preferredRectangleToConstrain: r)
						insetOriginBy: self class windowTopLeftHeadroom
						cornerBy: 0@0.
			r := r translatedBy: (r amountToTranslateWithin: bounds)].

	^r</body>
</methods>


<methods>
<class-id>UI.TextEditorController</class-id> <category>menu messages</category>

<body package="GsTools">accept
	"Save the current text of the text being edited as the current acceptable
	version for purposes of canceling."

	self gstUnboldTextKey: nil.
	self requestValueChange ifFalse: [^self].
	self privateAccept</body>
</methods>

<methods>
<class-id>UI.TextEditorController</class-id> <category>editing</category>

<body package="GsTools">gstUnboldTextKey: aCharEvent
	"If we try and unbold when continuousAccept is set to true. we get an infinite loop..."

	continuousAccept
		ifTrue: [^nil].

	^super gstUnboldTextKey: aCharEvent</body>
</methods>


<methods>
<class-id>GsTools class</class-id> <category>shortcut keys</category>

<body package="GsTools">winSetupShortcutsForKeyboard: aKeyboard

	aKeyboard
		defaultForCharacters: #normalCharacterKey:;
		defaultForNonCharacters: #ignoreInputKey:;
		"alt"
		bindValue: #selectAllKey: to: $a modifiers: #(#alt "#meta"); "select all"
		bindValue: #gstBrowseKey: to: $b modifiers: #(#alt "#meta"); "browse"
		bindValue: #copyKey: to: $c modifiers: #(#alt "#meta"); "copy"
		bindValue: #gstDoItKey: to: $d modifiers: #(#alt "#meta"); "do it"
		bindValue: #gstDebugKey: to: $e modifiers: #(#alt "#meta"); "debug"
		bindValue: #findDialogKey: to: $f modifiers: #(#alt "#meta"); "find"
		bindValue: #nextKey: to: $g modifiers: #(#alt "#meta"); "find again"
		bindValue: #gstInspectKey: to: $i modifiers: #(#alt "#meta"); "inspect it"
		bindValue: #cancelKey: to: $l modifiers: #(#alt "#meta"); "cancel"
		bindValue: #gstBrowseImplementorsKey: to: $m modifiers: #(#alt "#meta"); "implementors"
		bindValue: #gstBrowseSendersKey: to: $n modifiers: #(#alt "#meta"); "senders"
		bindValue: #gstPrintItKey: to: $p modifiers: #(#alt "#meta"); "print it"
		bindValue: #replaceDialogKey: to: $r modifiers: #(#alt "#meta"); "replace dialog"
		bindValue: #acceptKey: to: $s modifiers: #(#alt "#meta"); "accept/save"
		bindValue: #gstUnboldTextKey: to: $u modifiers: #(#alt "#meta"); "unbold (make plain text)"
		bindValue: #gstPasteKey: to: $v modifiers: #(#alt "#meta"); "paste"
		bindValue: #gstSwitchToWindow: to: $w modifiers: #(#alt "#meta"); "switch to another window"
		bindValue: #cutKey: to: $x modifiers: #(#alt "#meta"); "cut"
		bindValue: #undoKey: to: $z modifiers: #(#alt "#meta"); "undo"
		bindValue: #gstOutdentKey: to: $[ modifiers: #(#alt "#meta"); "shift selected text left 1 tab"
		bindValue: #gstIndentKey: to: $] modifiers: #(#alt "#meta"); "shift selected text right 1 tab"
		bindValue: #gstTypeArgument: to: $1 modifiers: #(#alt "#meta"); "paste arg 1"
		bindValue: #gstTypeArgument: to: $2 modifiers: #(#alt "#meta");  "paste arg 2"
		bindValue: #gstTypeArgument: to: $3 modifiers: #(#alt "#meta"); "paste arg 3"
		bindValue: #gstTypeArgument: to: $4 modifiers: #(#alt "#meta"); "paste arg 4"
		bindValue: #gstTypeArgument: to: $5 modifiers: #(#alt "#meta"); "paste arg 5"
		bindValue: #gstTypeArgument: to: $6 modifiers: #(#alt "#meta"); "paste arg 6"
		bindValue: #gstTypeArgument: to: $7 modifiers: #(#alt "#meta"); "paste arg 7"
		bindValue: #gstTypeArgument: to: $8 modifiers: #(#alt "#meta"); "paste arg 8"
		"control"
		bindValue: #copyKey: to: Ctrlc;
		bindValue: #acceptKey: to: Ctrls;
		bindValue: #gstPasteKey: to: Ctrlv;
		bindValue: #cutKey: to: Ctrlx;
		bindValue: #undoKey: to: Ctrlz;
		"special"

		bindValue: #gstBackspaceKey: to: Character backspace modifiers: #();
		bindValue: #cutKey: to: #Delete modifiers: #(#shift); "cut"
		bindValue: #copyKey: to: #Insert modifiers: #(#control); "copy"
		bindValue: #gstPasteKey: to: #Insert modifiers: #(#shift); "paste"
		bindValue: #gstExtendedPasteKey: to: #Insert modifiers: #(#control #shift); "extended paste"
		bindValue: #displayCRKey: to: #Enter modifiers: #();
		bindValue: #cursorUpKey: to: #Up modifiers: #();
		bindValue: #cursorDownKey: to: #Down modifiers: #();
		bindValue: #cursorLeftKey: to: #Left modifiers: #();
		bindValue: #cursorRightKey: to: #Right modifiers: #();
		bindValue: #homeKey: to: #Home modifiers: #();
		bindValue: #endKey: to: #End modifiers: #();
		bindValue: #pageUpKey: to: #PageUp modifiers: #();
		bindValue: #pageDownKey: to: #PageDown modifiers: #();
		bindValue: #gstCompleteKey: to: #Insert modifiers: #(); "auto complete selector or global"
		yourself</body>

<body package="GsTools">unixSetupShortcutsForKeyboard: aKeyboard

	aKeyboard
		defaultForCharacters: #normalCharacterKey:;
		defaultForNonCharacters: #ignoreInputKey:;
		bindValue: #selectAllKey: to: $a modifiers: #(#alt #meta); "select all"
		bindValue: #gstBrowseKey: to: $b modifiers: #(#alt #meta); "browse"
		bindValue: #copyKey: to: $c modifiers: #(#alt #meta); "copy"
		bindValue: #gstDoItKey: to: $d modifiers: #(#alt #meta); "do it"
		bindValue: #gstDebugKey: to: $e modifiers: #(#alt #meta); "debug"
		bindValue: #findDialogKey: to: $f modifiers: #(#alt #meta); "find"
		bindValue: #nextKey: to: $g modifiers: #(#alt #meta); "find again"
		bindValue: #gstInspectKey: to: $i modifiers: #(#alt #meta); "inspect it"
		bindValue: #cancelKey: to: $l modifiers: #(#alt #meta); "cancel"
		bindValue: #gstBrowseImplementorsKey: to: $m modifiers: #(#alt #meta); "implementors"
		bindValue: #gstBrowseSendersKey: to: $n modifiers: #(#alt #meta); "senders"
		bindValue: #gstPrintItKey: to: $p modifiers: #(#alt #meta); "print it"
		bindValue: #replaceDialogKey: to: $r modifiers: #(#alt #meta); "replace dialog"
		bindValue: #acceptKey: to: $s modifiers: #(#alt #meta); "accept/save"
		bindValue: #gstUnboldTextKey: to: $u modifiers: #(#alt #meta); "unbold (make plain text)"
		bindValue: #gstPasteKey: to: $v modifiers: #(#alt #meta); "paste"
		bindValue: #gstSwitchToWindow: to: $w modifiers: #(#alt #meta); "switch to another window"
		bindValue: #cutKey: to: $x modifiers: #(#alt #meta); "cut"
		bindValue: #undoKey: to: $z modifiers: #(#alt #meta); "undo"
		bindValue: #gstOutdentKey: to: $[ modifiers: #(#alt #meta); "shift selected text left 1 tab"
		bindValue: #gstIndentKey: to: $] modifiers: #(#alt #meta); "shift selected text right 1 tab"
		bindValue: #gstTypeArgument: to: $1 modifiers: #(#alt #meta); "paste arg 1"
		bindValue: #gstTypeArgument: to: $2 modifiers: #(#alt #meta);  "paste arg 2"
		bindValue: #gstTypeArgument: to: $3 modifiers: #(#alt #meta); "paste arg 3"
		bindValue: #gstTypeArgument: to: $4 modifiers: #(#alt #meta); "paste arg 4"
		bindValue: #gstTypeArgument: to: $5 modifiers: #(#alt #meta); "paste arg 5"
		bindValue: #gstTypeArgument: to: $6 modifiers: #(#alt #meta); "paste arg 6"
		bindValue: #gstTypeArgument: to: $7 modifiers: #(#alt #meta); "paste arg 7"
		bindValue: #gstTypeArgument: to: $8 modifiers: #(#alt #meta); "paste arg 8"
		"alt"
		bindValue: #selectAllKey: to: $a modifiers: #(#alt "#meta"); "select all"
		bindValue: #gstBrowseKey: to: $b modifiers: #(#alt "#meta"); "browse"
		bindValue: #copyKey: to: $c modifiers: #(#alt "#meta"); "copy"
		bindValue: #gstDoItKey: to: $d modifiers: #(#alt "#meta"); "do it"
		bindValue: #gstDebugKey: to: $e modifiers: #(#alt "#meta"); "debug"
		bindValue: #findDialogKey: to: $f modifiers: #(#alt "#meta"); "find"
		bindValue: #nextKey: to: $g modifiers: #(#alt "#meta"); "find again"
		bindValue: #gstInspectKey: to: $i modifiers: #(#alt "#meta"); "inspect it"
		bindValue: #cancelKey: to: $l modifiers: #(#alt "#meta"); "cancel"
		bindValue: #gstBrowseImplementorsKey: to: $m modifiers: #(#alt "#meta"); "implementors"
		bindValue: #gstBrowseSendersKey: to: $n modifiers: #(#alt "#meta"); "senders"
		bindValue: #gstPrintItKey: to: $p modifiers: #(#alt "#meta"); "print it"
		bindValue: #replaceDialogKey: to: $r modifiers: #(#alt "#meta"); "replace dialog"
		bindValue: #acceptKey: to: $s modifiers: #(#alt "#meta"); "accept/save"
		bindValue: #gstUnboldTextKey: to: $u modifiers: #(#alt "#meta"); "unbold (make plain text)"
		bindValue: #gstPasteKey: to: $v modifiers: #(#alt "#meta"); "paste"
		bindValue: #gstSwitchToWindow: to: $w modifiers: #(#alt "#meta"); "switch to another window"
		bindValue: #cutKey: to: $x modifiers: #(#alt "#meta"); "cut"
		bindValue: #undoKey: to: $z modifiers: #(#alt "#meta"); "undo"
		bindValue: #gstOutdentKey: to: $[ modifiers: #(#alt "#meta"); "shift selected text left 1 tab"
		bindValue: #gstIndentKey: to: $] modifiers: #(#alt "#meta"); "shift selected text right 1 tab"
		bindValue: #gstTypeArgument: to: $1 modifiers: #(#alt "#meta"); "paste arg 1"
		bindValue: #gstTypeArgument: to: $2 modifiers: #(#alt "#meta");  "paste arg 2"
		bindValue: #gstTypeArgument: to: $3 modifiers: #(#alt "#meta"); "paste arg 3"
		bindValue: #gstTypeArgument: to: $4 modifiers: #(#alt "#meta"); "paste arg 4"
		bindValue: #gstTypeArgument: to: $5 modifiers: #(#alt "#meta"); "paste arg 5"
		bindValue: #gstTypeArgument: to: $6 modifiers: #(#alt "#meta"); "paste arg 6"
		bindValue: #gstTypeArgument: to: $7 modifiers: #(#alt "#meta"); "paste arg 7"
		bindValue: #gstTypeArgument: to: $8 modifiers: #(#alt "#meta"); "paste arg 8"
		"control"
		bindValue: #copyKey: to: Ctrlc;
		bindValue: #acceptKey: to: Ctrls;
		bindValue: #gstPasteKey: to: Ctrlv;
		bindValue: #cutKey: to: Ctrlx;
		bindValue: #undoKey: to: Ctrlz;
		"special"

		bindValue: #gstBackspaceKey: to: Character backspace modifiers: #();
		bindValue: #cutKey: to: #Delete modifiers: #(#shift); "cut"
		bindValue: #copyKey: to: #Insert modifiers: #(#control); "copy"
		bindValue: #gstPasteKey: to: #Insert modifiers: #(#shift); "paste"
		bindValue: #gstExtendedPasteKey: to: #Insert modifiers: #(#control #shift); "extended paste"
		bindValue: #displayCRKey: to: #Enter modifiers: #();
		bindValue: #cursorUpKey: to: #Up modifiers: #();
		bindValue: #cursorDownKey: to: #Down modifiers: #();
		bindValue: #cursorLeftKey: to: #Left modifiers: #();
		bindValue: #cursorRightKey: to: #Right modifiers: #();
		bindValue: #homeKey: to: #Home modifiers: #();
		bindValue: #endKey: to: #End modifiers: #();
		bindValue: #pageUpKey: to: #PageUp modifiers: #();
		bindValue: #pageDownKey: to: #PageDown modifiers: #();
		bindValue: #gstCompleteKey: to: #Insert modifiers: #(); "auto complete selector or global"
		yourself</body>

<body package="GsTools">newSetupShortcutsForKeyboard: aKeyboard

	^ExternalInterface currentPlatform first == #win32
		ifTrue: [self winSetupShortcutsForKeyboard: aKeyboard]
		ifFalse: [self unixSetupShortcutsForKeyboard: aKeyboard]</body>
</methods>

<methods>
<class-id>GsTools class</class-id> <category>utility</category>

<body package="GsTools">formatClass: aClass
	"self formatClass: PROVISO.PvCmeEngine"
	
	| selectedClass |
	selectedClass := aClass.
	selectedClass selectorsAndMethodsDo: 
		[:selector :method | 
		self 
			formatMethod: method
			inClass: aClass]</body>

<body package="GsTools">formatMethod: method
	inClass: aClass
	
	| newText |
	newText := 
		([Refactory.Browser.RBParser parseMethod: method getSource] 
			on: Error
			do: 
				[:aString :position | 
				^Transcript
					cr;
					show: aString]) printString.
	newText isNil 
		ifTrue: 
			[^Transcript
				cr;
				show: 'Nothing compiled'].
	aClass 
		compile: newText
		classified: (aClass whichCategoryIncludesSelector: (aClass selectorAtMethod: method ifAbsent: [nil]))</body>
</methods>

<methods>
<class-id>GsTools class</class-id> <category>colors</category>

<body package="GsTools">setBrowserTextColors
	"To use this you must:
		1. Load the ColorEditiing Parcel.
		2. Use File-&gt;Settings and go to the color tab
			- Select the default colors
			- Click the accept butto
		3. Execute the following statements:
			GsTools setBrowserTextColors.
			Win95WidgetPolicy initializeDefaultGenericColors.
		4. Restart your image.
	"

	| colorSet colors colorMap |
	colorSet := Dictionary new
		at: #commentColor put: ColorValue darkGreen;
		at: #variableColor put: ColorValue navy;
		at: #instanceVariableColor put: ColorValue blue;
		at: #literalColor put: ColorValue darkMagenta;
		at: #globalColor put: ColorValue darkRed;
		at: #undeclaredColor put: ColorValue red;
		at: #returnColor put: ColorValue red;
		at: #primitiveColor put: ColorValue orange asShadowColor;
		at: #defaultColor put: ColorValue black;
		yourself.

	colors := #(
		(argumentColor variableColor)
		(arrayColor literalColor)
		(assignmentColor defaultColor)
		(blockLevel10Color defaultColor)
		(blockLevel1Color defaultColor)
		(blockLevel2Color defaultColor)
		(blockLevel3Color defaultColor)
		(blockLevel4Color defaultColor)
		(blockLevel5Color defaultColor)
		(blockLevel6Color defaultColor)
		(blockLevel7Color defaultColor)
		(blockLevel8Color defaultColor)
		(blockLevel9Color defaultColor)
		(cascadeColor returnColor)
		(characterColor literalColor)
		(classColor variableColor)
		(commentColor commentColor)
		(constantColor variableColor)
		(globalColor globalColor)
		(instanceColor instanceVariableColor)
		(methodCommentColor commentColor)
		(numberColor literalColor)
		(parenthesisLevel10Color defaultColor)
		(parenthesisLevel1Color defaultColor)
		(parenthesisLevel2Color defaultColor)
		(parenthesisLevel3Color defaultColor)
		(parenthesisLevel4Color defaultColor)
		(parenthesisLevel5Color defaultColor)
		(parenthesisLevel6Color defaultColor)
		(parenthesisLevel7Color defaultColor)
		(parenthesisLevel8Color defaultColor)
		(parenthesisLevel9Color defaultColor)
		(poolDictionaryColor variableColor)
		(primitiveColor primitiveColor)
		(returnColor returnColor)
		(selectorColor defaultColor)
		(selfColor variableColor)
		(stringColor literalColor)
		(superColor variableColor)
		(symbolColor literalColor)
		(temporaryColor variableColor)
		(thisContextColor defaultColor)
		(undeclaredColor undeclaredColor)).

	colorMap := IdentityDictionary new.
	colors do: [:eachPair |
		colorMap at: eachPair first put: (Array with: (#color -&gt; (colorSet at: eachPair last)))].

	(UI.UISettings preferenceModelFor: #textEditingColorDictionaryEditing ) value: colorMap.
	colorMap keys do: [:key |
		colorMap at: key put: ((colorMap at: key) select: [:i | i class == Association])].

	UI.UISettings browserColorAccept</body>
</methods>

<methods>
<class-id>GsTools class</class-id> <category>store stream version</category>

<body package="GsTools">storeStreamVersion

	^StoreStreamVersion isNil
		ifTrue: ['*']
		ifFalse: [StoreStreamVersion]</body>

<body package="GsTools">storeStreamVersion: aString

	StoreStreamVersion := aString</body>
</methods>


<methods>
<class-id>Store.PundleModel</class-id> <category>printing</category>

<body package="GsTools">textForItem
	"Descriptive text for the browser text window."

	| stream dbId |
	stream := TextStream on: ( String new: 80 ).
	stream nextPutAll: self name; cr.
	dbId := DbRegistry dbIdentifier.
	self databaseInformationsDo:
		[ :info | | id | 
		id := info dbIdentifier.
		id = dbId ifTrue: [ stream emphasis: #bold ].
		id == nil ifTrue: [ id := '' ].
 		stream tab; nextPutAll: 
			( id, info versionString,
					( ( self hasBeenModifiedIn: id )
						ifTrue: [ '*' ]
						ifFalse: [ '=' ]
					)
			).
		stream emphasis: #normal.
		stream cr.
		(self tracePackage notNil and:[DbRegistry isOnline and: [self tracePackage isInCurrentDatabase]])
			ifTrue: 
				[stream nextPutAll: ( Blessing blessingHistoryForPundle:  self tracePackage ) asString].
		].
	^stream contents</body>
</methods>


<methods>
<class-id>Tools.SelectorBrowserHelper</class-id> <category>list accessing</category>

<body package="GsTools">updateListFull

	| newList target |
	newList := ( self protocol == nil )  |  ( ( target := self targetClassOrNameSpace ) == nil )
		ifTrue: [ ^module setNewList: List new]
		ifFalse: 	[ (target organization listAtCategoryNamed: self protocol) asSortedCollection asList ].
	
	target isForNameSpace
		ifTrue: [ newList := newList select: [ :key | ( target bindingFor: key ) isForGeneral ] ].
	module setNewList: newList asList</body>
</methods>


<methods>
<class-id>UI.MotifMenuBarButtonView</class-id> <category>privileged</category>

<body package="GsTools">processShortcutKeyEventAsMenuBarAccessor: aKeyboardEvent
	"Disable menu shortcuts"

	^false</body>
</methods>


<methods>
<class-id>Tools.ProtocolBrowserHelper</class-id> <category>list accessing</category>

<body package="GsTools">updateListFull

	| newList target |
	( target := self targetClassOrNameSpace ) == nil
		ifTrue: [ newList := List new ]
		ifFalse: [ newList := target organization categories asSortedCollection asList ].
	module setNewList: newList</body>
</methods>


<methods>
<class-id>Store.PackageBrowserHelper</class-id> <category>actions</category>

<body package="GsTools">diffPackageWithParent
	"Spawn a difference browser on a selected package and 
	on its trace."

	self dbManager doIfOnlineImage: 
		[ self packages do: 
			[ :each |  	| pkg trace |
			pkg := each hasBeenModified
				ifTrue: [ each ]
				ifFalse: [ each ].
			( trace := pkg parentRecord ) isNil 
				ifTrue: [ trace := pkg selectVersion ].
			trace == nil 	ifTrue: [ ^self ].
			pkg isPackage
				ifTrue: [ ComparisonBrowser comparePackage: pkg toPackage: trace ]
				ifFalse: [ BundleDifferenceBrowser compare: pkg with: trace ]
			]
		]</body>
</methods>



</st-source>

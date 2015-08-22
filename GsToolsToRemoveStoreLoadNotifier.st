<?xml version="1.0"?>

<st-source>
<time-stamp>From VisualWorks®, Release 5i.4 of August 9, 2001 on March 29, 2002 at 6:18:26 am</time-stamp>
<!-- Package GsToolsToRemoveStoreLoadNotifier(3.0.3,sourcecontrol) -->








<methods>
<class-id>Store.Notice class</class-id> <category>instance creation</category>

<body package="GsToolsToRemoveStoreLoadNotifier">showProgress: aString complete: anInteger progress: bString complete: bInteger while: aBlock 
	"Show a progress indicator window while executing a block of code.
	anInteger is the completeness count (ie = 100%).
	IncrementNotification is raised to denote progress."
	"self  showProgress: 'X' complete: 10000 progress: 'ABCDEF' complete: 1000 while: 
		[ 10000 timesRepeat: [ 1777 / 987. IncrementNotification raiseSignal ] ]"

	^self unobtrusiveShowProgress: aString while: aBlock
"
	| increment progress pw res progress2 |
	increment := 1.0 / anInteger. 
	progress := 0.0 asValue.
	progress2 := 0.0 asValue.
	pw := ProgressWidgetView 
			progressOpenOn: progress label: aString asText allBold
			on: progress2 label: bString asText allBold.
	[ [ Cursor wait showWhile: [ res := aBlock value ] ] on: IncrementNotification do:
		[ :not | 
		progress value: ( progress value + ( not ticks * increment ) ).
		not resume.
		 ].
	[ Cursor wait showWhile: [ res := aBlock value ] ] on: IncrementNotification do:
		[ :not | 
		progress2 value: ( progress2 value + ( not ticks * increment ) ).
		not resume.
		 ]
	] ensure: [ pw closeAndUnschedule ].
	^res
"</body>

<body package="GsToolsToRemoveStoreLoadNotifier">unobtrusiveShowProgress: aString while: aBlock

	Cursor wait showWhile:
		[^aBlock value]</body>

<body package="GsToolsToRemoveStoreLoadNotifier">showProgress: aString complete: anInteger while: aBlock 
	"Show a progress indicator window while executing a block of code.
	anInteger is the completeness count (ie = 100%).
	IncrementNotification is raised to denote progress."
	"self  showProgress: 'X' complete: 10000 while: 
		[ 10000 timesRepeat: [ IncrementNotification raiseSignal ] ]"


	^self unobtrusiveShowProgress: aString while: aBlock

	"
	| increment progress pw res int |
	int := anInteger isZero ifTrue: [ 1 ] ifFalse: [ anInteger ].
	increment := 1.0 / int. 
	progress := 0.0 asValue.
	pw := ProgressWidgetView progressOpenOn: progress label: aString asText allBold.
	[ [ Cursor wait showWhile: [ res := aBlock value ] ] on: IncrementNotification do:
		[ :not | 
		progress value: ( progress value + ( not ticks * increment ) ).
		not resume.
		 ]
	] ensure: [ pw closeAndUnschedule ].
	^res
	"</body>

<body package="GsToolsToRemoveStoreLoadNotifier">show: aString while: aBlock 
	"Show a notice window while executing a block of code."
	"self show: 'In progress' while: [1 to: 30000 do: [:i| i*i*i]]"

	^self unobtrusiveShowProgress: aString while: aBlock

	"
	| baby res |
	baby := self new.
	baby message: aString asText allBold.
	self halt.
	[ res := baby open.
	( Delay forMilliseconds: 250 ) wait.
	ScheduledControllers checkForEvents.
	Cursor wait showWhile: [ res := aBlock value ] ]
		ensure: [ baby closeRequest ].
	^res
	"</body>
</methods>


<methods>
<class-id>Store.Package</class-id> <category>private-loading</category>

<body package="GsToolsToRemoveStoreLoadNotifier">sourceLoadFromDBloadWithin: parentBundle warnReplace: warnReplace
	"Load the package from DB. 	If the user does not want to replace the loaded version answer the
	existing image package. Note: catch errors during the load."

	| imPkg loadRes |
	imPkg := self createImagePundle.
	(warnReplace and: [imPkg canReplaceVersions not]) ifTrue: [^imPkg].
	Policies packagePolicy forcePackage: imPkg while: 
		[ XMainChangeSet ignoreMainChangesWhile: 
			[Transcript cr; show: 'Loading package ' , self name, '...'.
				loadRes := imPkg isClean
					ifTrue: [ self doSourceLoad: imPkg within: parentBundle]
					ifFalse: [ self doDiffSourceLoad: imPkg within: parentBundle ].
			Transcript show: 'done'.
			].
			loadRes ifTrue: [ self postLoad: imPkg ]
		].
	^loadRes
		ifTrue: [ imPkg ]
		ifFalse: [ nil ]</body>
</methods>



</st-source>

"
History of evaluation input previously entered

You can use the single character alias ! even without a space

history - print a summary of the history
history all - print the full history
history clear - clear the full history
history <integer> - execute a previous input again
history last - execute the last input again
history ! - execute the last input again
"
Class {
	#name : #ConsoleHistoryCommand,
	#superclass : #ConsoleCommand,
	#category : #'Console-Core'
}

{ #category : #accessing }
ConsoleHistoryCommand class >> defaultName [
	^ 'History'
]

{ #category : #testing }
ConsoleHistoryCommand class >> handlesLine: line [
	^ line first = $! or: [ super handlesLine: line ]
]

{ #category : #public }
ConsoleHistoryCommand >> execute [
	self hasArguments
		ifTrue: [
			self argument = 'all' 
				ifTrue: [ self history ].
			self argument = 'clear' 
				ifTrue: [ self historyClear ].
			(Integer readFrom: self argument ifFail: [ nil ]) 
				ifNotNil: [ :index | self executeHistoryAt: index ].
			(#(last !) includes: self argument)
				ifTrue: [ self executeHistoryLast ] ]
		ifFalse: [ self historySummary ]
]

{ #category : #private }
ConsoleHistoryCommand >> executeHistoryAt: index [
	| input evalCommand |
	[ 
	input := Console history at: index.
	evalCommand := ConsoleEvalCommand new on: input.
	evalCommand execute.
	result := input , String cr , String cr , evalCommand result ]
		on: SubscriptOutOfBounds
		do: [ result := 'no history item @ ' , index asString ]
]

{ #category : #private }
ConsoleHistoryCommand >> executeHistoryLast [
	| size |
	size := Console history size.
	size isZero 
		ifTrue: [ result := 'history is empty' ]
		ifFalse: [ self executeHistoryAt: size ]
]

{ #category : #private }
ConsoleHistoryCommand >> history [
	result := String streamContents: [ :out |
		1 to: Console history size do: [ :each |
			out print: each; << ': '; << (Console history at: each); cr ] ]
]

{ #category : #private }
ConsoleHistoryCommand >> historyClear [
	Console history removeAll.
	result := 'history cleared'
]

{ #category : #private }
ConsoleHistoryCommand >> historySummary [
	result := String streamContents: [ :out | | size |
		size := Console history size.
		(1 max: (size - self historySummarySize)) to: size do: [ :each |
			out print: each; << ': '; << (Console history at: each); cr ] ]
]

{ #category : #accessing }
ConsoleHistoryCommand >> historySummarySize [
	^ 10
]

{ #category : #'initialization-release' }
ConsoleHistoryCommand >> on: input [
	super on: input.
	self argument first = $!
		ifTrue: [ 
			arguments := self argument allButFirst findTokens: Character separators ]
		ifFalse: [ 
			arguments := self argument findTokens: Character separators.
			arguments := arguments allButFirst ]
]

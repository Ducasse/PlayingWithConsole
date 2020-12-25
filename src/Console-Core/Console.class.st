"
I am a class facade offering access to some global state held by the NeoConsole package.

I hold the history of all evaluated commands.

I hold the last 3 results.

I offer quick access to NeoConsoleEnvironment current.
"
Class {
	#name : #Console,
	#superclass : #Object,
	#classVars : [
		'History',
		'Results'
	],
	#category : #'Console-Core'
}

{ #category : #accessing }
Console class >> clearResults [
	^ self results 
		atAllPut: nil; 
		yourself
]

{ #category : #accessing }
Console class >> env [
	^ ConsoleEnvironment current
]

{ #category : #accessing }
Console class >> history [
	^ History ifNil: [ History := OrderedCollection new ]
]

{ #category : #accessing }
Console class >> last [
	^ self results last
]

{ #category : #accessing }
Console class >> lastResult: anObject [
	| results |
	results := self results.
	anObject = results ifTrue: [ ^ results ].
	results at: 1 put: (results at: 2).
	results at: 2 put: (results at: 3).
	results at: 3 put: anObject.
	^ results
]

{ #category : #accessing }
Console class >> results [
	^ Results ifNil: [ Results := Array new: 3 ]
]

{ #category : #server }
Console class >> startServer [
	^ ConsoleTelnetServer new start
]

{ #category : #server }
Console class >> startServerOn: port [
	^ ConsoleTelnetServer startOn: port
]

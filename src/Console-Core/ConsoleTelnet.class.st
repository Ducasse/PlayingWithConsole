"
I am a class facade offering access to some global state held by the Console package.

I hold the history of all evaluated commands.

I hold the last 3 results.

I offer quick access to ConsoleEnvironment current.
"
Class {
	#name : #ConsoleTelnet,
	#superclass : #Object,
	#classVars : [
		'History',
		'Results'
	],
	#category : #'Console-Core'
}

{ #category : #accessing }
ConsoleTelnet class >> clearResults [
	^ self results 
		atAllPut: nil; 
		yourself
]

{ #category : #accessing }
ConsoleTelnet class >> env [
	^ ConsoleEnvironment current
]

{ #category : #accessing }
ConsoleTelnet class >> history [
	^ History ifNil: [ History := OrderedCollection new ]
]

{ #category : #accessing }
ConsoleTelnet class >> last [
	^ self results last
]

{ #category : #accessing }
ConsoleTelnet class >> lastResult: anObject [
	| results |
	results := self results.
	anObject = results ifTrue: [ ^ results ].
	results at: 1 put: (results at: 2).
	results at: 2 put: (results at: 3).
	results at: 3 put: anObject.
	^ results
]

{ #category : #accessing }
ConsoleTelnet class >> results [
	^ Results ifNil: [ Results := Array new: 3 ]
]

{ #category : #server }
ConsoleTelnet class >> startServer [
	^ ConsoleTelnetServer new start
]

{ #category : #server }
ConsoleTelnet class >> startServerOn: port [
	^ ConsoleTelnetServer startOn: port
]

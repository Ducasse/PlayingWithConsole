"
I am NeoConsoleTelnetServerTests, holding functional unit tests for NeoConsoleTelnetServer
"
Class {
	#name : #ConsoleTelnetServerTest,
	#superclass : #ConsoleTest,
	#instVars : [
		'server',
		'connection',
		'in',
		'out'
	],
	#category : #'Console-Core'
}

{ #category : #accessing }
ConsoleTelnetServerTest >> localhost [
	^ #[127 0 0 1] asSocketAddress
]

{ #category : #running }
ConsoleTelnetServerTest >> setUp [ 
	super setUp.
	server := ConsoleTelnetServer new start.
	connection := ZdcSocketStream openConnectionToHost: self localhost port: server port timeout: 10.
	in := ZnCharacterReadStream on: connection.
	out := ZnCharacterWriteStream on: connection.
]

{ #category : #running }
ConsoleTelnetServerTest >> tearDown [
	server stop.
	super tearDown 
]

{ #category : #testing }
ConsoleTelnetServerTest >> testConnect [

	| line |
	line := in nextLine.
	self assert: (line includesSubstring: 'Console').
	line := in next: 7.
	self assert: line equals: 'pharo>>'.
	out nextPutAll: 'quit'; lf; flush.
	line := in nextLine.
	self assert: line equals: '> Bye!'.
	connection close
]

{ #category : #testing }
ConsoleTelnetServerTest >> testEvalSum [
	| line x y |
	line := in nextLine.
	self assert: (line includesSubstring: 'Console').
	line := in next: 7.
	self assert: line equals: 'pharo>>'.
	x := 999 atRandom.
	y := 999 atRandom.
	out nextPutAll: ('eval {1} + {2}' format: { x. y }); lf; lf; flush.
	line := in nextLine.
	self assert: (line allButFirst: 2) asNumber equals: x + y.
	out nextPutAll: 'quit'; lf; flush.
	connection close
]

{ #category : #testing }
ConsoleTelnetServerTest >> testGetSystemTimestamp [
	| line |
	in nextLine.
	in next: 7.
	out nextPutAll: 'get system.timestamp'; lf; flush.
	line := in nextLine.
	self assert: DateAndTime now - (DateAndTime fromString: line) < 5 seconds.
	out nextPutAll: 'quit'; lf; flush.
	connection close
]

{ #category : #testing }
ConsoleTelnetServerTest >> testSumMultiline [
	| line x y |
	line := in nextLine.
	self assert: (line includesSubstring: 'Console').
	line := in next: 7.
	self assert: line equals: 'pharo>>'.
	x := 999 atRandom.
	y := 999 atRandom.
	out print: x; lf; nextPut: $+; lf; print: y; lf; lf; flush.
	line := in nextLine.
	self assert: (line allButFirst: 2) asNumber equals: x + y.
	out nextPutAll: 'quit'; lf; flush.
	connection close
]

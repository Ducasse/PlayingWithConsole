Class {
	#name : #ConsoleLogic,
	#superclass : #Object,
	#category : #'Console-Core'
}

{ #category : #protocol }
ConsoleLogic >> exceptionClasses [ 

	^ ConnectionClosed, ConnectionTimedOut 
]

{ #category : #protocol }
ConsoleLogic >> readInputFrom: stream [
	| input lineReader line commandClass |
	lineReader := ZnFastLineReader on: stream.
	line := [ lineReader nextLine trimBoth ] on: self exceptionClasses do: [ nil ].
	line isEmptyOrNil ifTrue: [ ^ ConsoleQuitCommand new ].
	commandClass := ConsoleCommand forLine: line.
	commandClass isSingleLine
		ifTrue: [ ^ commandClass new on: line; yourself ].
	input := String new writeStream.
	input nextPutAll: line; cr.
	[ 
		line := [ lineReader nextLine trimBoth ] on: self exceptionClasses do: [ '' ].
		input nextPutAll: line; cr.
		line isEmpty ] whileFalse.
	^ commandClass new on: input contents; yourself
]

{ #category : #protocol }
ConsoleLogic >> writeLine: string to: stream [
	stream nextPutAll: string; lf; flush
]

{ #category : #protocol }
ConsoleLogic >> writeOutput: string to: stream [
	string lines
		do: [ :each | stream nextPutAll: each ]
		separatedBy: [ stream lf ].
	stream lf; flush
]

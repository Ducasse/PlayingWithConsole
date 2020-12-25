"
I am ConsoleCommand. I describe a command that can be executed by the Console infrastructure. I am abstract.

The class comments of my subclasses are used as help texts in the command line interface.
"
Class {
	#name : #ConsoleCommand,
	#superclass : #CmCommand,
	#instVars : [
		'arguments',
		'result'
	],
	#category : #'Console-Core'
}

{ #category : #accessing }
ConsoleCommand class >> consoleCommandName [
	"We take the command name and expose part of it as a console command."
	
	^ (self defaultName copyUpTo: Character space) asLowercase
]

{ #category : #accessing }
ConsoleCommand class >> defaultCommand [
	^ ConsoleEvalCommand 
]

{ #category : #accessing }
ConsoleCommand class >> forLine: line [
	| commandClass |
	commandClass := self knownCommands 
		detect: [ :each | each handlesLine: line ] 
		ifNone: [ self defaultCommand ].
	^ commandClass
]

{ #category : #testing }
ConsoleCommand class >> handlesLine: line [
	^ line beginsWith: self consoleCommandName
]

{ #category : #accessing }
ConsoleCommand class >> helpText [
	^ String streamContents: [ :out |
			out << self name; cr.
			self comment linesDo: [ :each | 
				out space; space; << each; cr ] ]
]

{ #category : #testing }
ConsoleCommand class >> isMultiLine [
	^ self isSingleLine not
]

{ #category : #testing }
ConsoleCommand class >> isSingleLine [
	^ true
]

{ #category : #accessing }
ConsoleCommand class >> knownCommands [
	^ self subclasses
]

{ #category : #accessing }
ConsoleCommand >> argument [
	^ arguments first
]

{ #category : #accessing }
ConsoleCommand >> arguments [
	^ arguments 
]

{ #category : #public }
ConsoleCommand >> execute [
	self subclassResponsibility 
]

{ #category : #testing }
ConsoleCommand >> hasArguments [
	^ arguments notNil and: [ arguments notEmpty ]
]

{ #category : #private }
ConsoleCommand >> logException: exception on: out [
	out print: exception; cr.
	exception signalerContext printDetails: out.
	exception signalerContext sender debugStack: 8 on: out
]

{ #category : #'initialization-release' }
ConsoleCommand >> on: input [
	arguments := Array with: input trimBoth
]

{ #category : #accessing }
ConsoleCommand >> result [
	^ result
]

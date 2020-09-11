"
I am BaselineOfNeoConsole, I load the NeoConsole project's code.
I am a BaselineOf.

NeoConsole offers a command line (REPL) interface to a Pharo image.
"
Class {
	#name : #BaselineOfConsole,
	#superclass : #BaselineOf,
	#category : #BaselineOfConsole
}

{ #category : #baselines }
BaselineOfConsole >> baseline: spec [
	<baseline>
	spec for: #common do: [ spec package: 'Neo-Console-Core' ]
]

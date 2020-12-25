"
Get some minimal help

You can use the single character alias ?

help - list all commands
help <command> - print help about <command>
"
Class {
	#name : #ConsoleHelpCommand,
	#superclass : #ConsoleCommand,
	#category : #'Console-Core'
}

{ #category : #testing }
ConsoleHelpCommand class >> defaultName [
	^ 'help'
]

{ #category : #testing }
ConsoleHelpCommand class >> handlesLine: line [
	^ line first = $? or: [ super handlesLine: line ]
]

{ #category : #public }
ConsoleHelpCommand >> execute [
	self hasArguments 
		ifTrue: [ 
			(ConsoleCommand knownCommands 
					detect: [ :each | each consoleCommandName = self argument ] ifNone: [ nil ])
				ifNil: [ result := 'unknown command <{1}>' format: { self argument } ] 
				ifNotNil: [ :command | result := command helpText ] ]
		ifFalse: [ 
			result := String streamContents: [ :out |
				out << 'help <command>'; cr.
				out << 'known commands are:'; cr.
				ConsoleCommand knownCommands 
					do: [ :each | 
						out space; space; << each consoleCommandName.
						ConsoleCommand defaultCommand = each ifTrue: [ out << ' DEFAULT' ] ] 
					separatedBy: [ out cr ] ] ]
]

{ #category : #'initialization-release' }
ConsoleHelpCommand >> on: input [
	super on: input.
	arguments := self argument findTokens: Character separators.
	arguments := arguments allButFirst 
]

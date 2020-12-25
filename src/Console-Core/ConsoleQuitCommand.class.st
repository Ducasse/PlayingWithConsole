"
Quit

You can also hit <ENTER> (input an empty line) or enter <CTRL-D><ENTER>.

quit - Quit the REPL

"
Class {
	#name : #ConsoleQuitCommand,
	#superclass : #ConsoleCommand,
	#category : #'Console-Core'
}

{ #category : #accessing }
ConsoleQuitCommand class >> defaultName [ 
	^ 'Quit console'
]

{ #category : #testing }
ConsoleQuitCommand class >> handlesLine: line [
	^ line first = Character end "Ctrl-D" or: [ super handlesLine: line ]
]

{ #category : #public }
ConsoleQuitCommand >> execute [
	result := 'Bye!'.
	^ nil
]

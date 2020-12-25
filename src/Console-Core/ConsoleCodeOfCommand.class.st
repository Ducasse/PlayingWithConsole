"
Show the source code of a class or method

show <Class> - show the definition of <Class>
show <Class>>>#<Method> - show the source code of <Method> in <Class>

Examples

show Point

- show the definition of Point

show Point>>#hash

- show the source code of the method #hash of class Point

show Character class>>#euro

- show the source code of the class method #euro of class Point



"
Class {
	#name : #ConsoleCodeOfCommand,
	#superclass : #ConsoleCommand,
	#category : #'Console-Core'
}

{ #category : #accessing }
ConsoleCodeOfCommand class >> defaultName [ 
	^ 'Code of Class/Method'
]

{ #category : #public }
ConsoleCodeOfCommand >> execute [
	self hasArguments 
		ifTrue: [ | thing |
			thing := [ self class compiler evaluate: self argument ] on: Exception do: [ nil ].
			thing
				ifNil: [ result := 'Not a class or method ', self argument ]
				ifNotNil: [ 
					result := 'Not a class or method ', thing printString.
					thing isClass 
						ifTrue: [ result := thing definition ].
					(thing respondsTo: #sourceCode)
						ifTrue: [ result := thing printString, String cr, thing sourceCode ] ] ]
		ifFalse: [ 
			result := self class comment ]
]

{ #category : #'initialization-release' }
ConsoleCodeOfCommand >> on: input [
	super on: input.
	(self argument beginsWith: self class consoleCommandName)
		ifTrue: [ arguments := Array with: (self argument allButFirst: self class consoleCommandName size) trimBoth ]
]

"
### Evaluate a Pharo expression

The following command
```
eval <expression>
<expression> continued
<empty line>
```
evaluates a multi line expression and show the result

### Default command
Eval is normally the default command, no need to type 'eval'

```
eval 1+2
```
evaluates the expression 1+2

```
(1 to: 10) collect: [ :each |
  each * each ]
```
evaluates the multi line expression, doubling the numbers 1 to 10 in a collection
"
Class {
	#name : #ConsoleEvalCommand,
	#superclass : #ConsoleCommand,
	#category : #'Console-Core'
}

{ #category : #accessing }
ConsoleEvalCommand class >> defaultName [
	^ 'eval'
]

{ #category : #testing }
ConsoleEvalCommand class >> isSingleLine [
	^ false
]

{ #category : #public }
ConsoleEvalCommand >> execute [
	result := String 
		streamContents: [ :out | 
			[ 	| compiler evaluationResult |
				compiler := self class compiler.
				ConsoleTelnet history add: self argument.
				evaluationResult := compiler evaluate: self argument.
				ConsoleTelnet lastResult: evaluationResult. 
				out print: evaluationResult ]
					on: Error , SyntaxErrorNotification 
					do: [ :exception | self logException: exception on: out ] ]
		limitedTo: self outputLimit.
	result size < self outputLimit 
		ifFalse: [ result := result , ' ... (truncated) ...' ]
]

{ #category : #initialization }
ConsoleEvalCommand >> on: input [
	super on: input.
	(self argument beginsWith: self class consoleCommandName)
		ifTrue: [ arguments := Array with: (self argument allButFirst: self class consoleCommandName size) trimBoth ]
]

{ #category : #accessing }
ConsoleEvalCommand >> outputLimit [
	^ 16384
]

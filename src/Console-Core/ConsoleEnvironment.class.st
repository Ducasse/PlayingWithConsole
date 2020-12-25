"
`ConsoleEnvironment` holds a number of configuration key/value pairs and can be used for system configuration during startup. `ConsoleEnvironment` offers a single, central place for configuration.

For example, in your run/startup script you could write: 

```
ConsoleEnvironment current
	at: #DatabaseUsername put: 'webapp';
	at: #DatabasePassword put: 'secret'.
```	
And use those values when you make a database connection once your application starts up.

You can optionally request to load the key/value of your OS environment using `#loadOSEnvironment`.

```
ConsoleEnvironment current
	loadOSEnvironment;
	yourself.
```

Keys are stored as symbols.

"
Class {
	#name : #ConsoleEnvironment,
	#superclass : #Object,
	#instVars : [
		'environment'
	],
	#classVars : [
		'UniqueInstance'
	],
	#category : #'Console-Core'
}

{ #category : #accessing }
ConsoleEnvironment class >> current [
	^ UniqueInstance ifNil: [ UniqueInstance := self new ]
]

{ #category : #accessing }
ConsoleEnvironment class >> default [
	^ self current
]

{ #category : #accessing }
ConsoleEnvironment >> at: key [
	"Return my value for key.
	Signal NotFound if I do not know key."
	
	^ environment at: key
]

{ #category : #accessing }
ConsoleEnvironment >> at: key ifAbsent: block [
	"Return my value for key.
	Return the value of evaluating block in case I do not know key."
	
	^ environment at: key ifAbsent: block
]

{ #category : #accessing }
ConsoleEnvironment >> at: key ifAbsentPut: block [
	"Return my value for key.
	Store and return the value of evaluating block in case I do not know key."

	^ environment at: key ifAbsentPut: block
]

{ #category : #accessing }
ConsoleEnvironment >> at: key ifPresent: block [
	"Return the value of evaluating block with my value for key.
	Return self, in effect do nothing, in case I do not know key."

	^ environment at: key ifPresent: block
]

{ #category : #accessing }
ConsoleEnvironment >> at: key put: value [
	"I will store value for key.
	Return value."
	
	^ environment at: key asSymbol put: value
]

{ #category : #testing }
ConsoleEnvironment >> includesKey: key [
	^ environment includesKey: key
]

{ #category : #initialization }
ConsoleEnvironment >> initialize [
	super initialize.
	environment := Dictionary new
]

{ #category : #accessing }
ConsoleEnvironment >> keys [
	^ environment keys
]

{ #category : #enumeration }
ConsoleEnvironment >> keysAndValuesDo: block [
	environment keysAndValuesDo: block
]

{ #category : #initialization }
ConsoleEnvironment >> loadOSEnvironment [

	OSPlatform current environment 
		keysAndValuesDo: [ :key :value | 
			self at: key put: value ]
]

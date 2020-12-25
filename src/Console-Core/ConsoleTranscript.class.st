"
I am ConsoleTranscript, a NonInteractiveTranscript that writes to a dated file, switching to a new file each day.

```
	(ConsoleTranscript onFileNamed: 'server-{1}.log') install.
```
"
Class {
	#name : #ConsoleTranscript,
	#superclass : #NonInteractiveTranscript,
	#instVars : [
		'date'
	],
	#category : #'Console-Core'
}

{ #category : #constants }
ConsoleTranscript class >> defaultLogFileName [
	"The default file name that will be used to write to.
	This needs to have a slot where the date will come."
	
	^ 'PharoTranscript-{1}.log'
]

{ #category : #accessing }
ConsoleTranscript >> fileNameWithDate [
	| newName |
	newName := self fileName format: { date yyyymmdd }.
	self 
		assert: self fileName ~= newName 
		description: 'The filename should include a {1} slot for the date'.
	^ newName
]

{ #category : #initialization }
ConsoleTranscript >> initialize [
	super initialize.
	date := Date today
]

{ #category : #private }
ConsoleTranscript >> initializeStream [
	"Open the file stream that I write to or connect to #stdout.
	I will append to regular files.
	Overwritten to use #fileNameWithDate"
	
	stream := self isStdout 
		ifTrue: [ Stdio stdout ]
		ifFalse: [ self fileNameWithDate asFileReference writeStream ].
	self isStdout
		ifTrue: [ stream converter "Force lazy initialization of converter" ] 
		ifFalse: [ stream setToEnd ].
	^ stream
]

{ #category : #accessing }
ConsoleTranscript >> stream [ 
	"Overwritten to check if the date changed on each access"
	
	Date today > date
		ifTrue: [ 
			"The date changed: close the old file and advance the date"
			self close.
			date := Date today ].
	"Since stream is now nil, #initializeStream will be called"
	^ super stream
]

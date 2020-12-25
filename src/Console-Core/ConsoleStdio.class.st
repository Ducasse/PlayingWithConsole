"
ConsoleStdio offers a command line interface to a Pharo image over Stdio.

```
  $ ./pharo Pharo.image ConsoleStdio run
```
End with quit or an empty line.

Security warning: this service opens up your image for access to those with access to your local network (i.e. those logged in to your machine), without any further authenication, allowing them to do absolutely anything. Think and make sure that you know what you are doing.
"
Class {
	#name : #ConsoleStdio,
	#superclass : #ConsoleLogic,
	#category : #'Console-Core'
}

{ #category : #public }
ConsoleStdio class >> run [
	^ self new run
]

{ #category : #protocol }
ConsoleStdio >> executeRequestResponseLoop [

	self initializeInOut.
	self sayHello.
	self handleLoop
]

{ #category : #protocol }
ConsoleStdio >> initializeInOut [
	
	in := ZnCharacterReadStream on: Stdio stdin binary.
	out := ZnCharacterWriteStream on: Stdio stdout.
]

{ #category : #public }
ConsoleStdio >> run [
	self executeRequestResponseLoop 

]

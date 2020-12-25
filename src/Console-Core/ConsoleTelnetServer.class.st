"
ConsoleTelnetServer offers a command line interface to a Pharo image over a network connection.

Inspect:
```
  ConsoleTelnetServer new start.
```

In a terminal do:

```
  $ telnet localhost 4999
```

End with quit or an empty line.

Security warning: this service opens up your image for access to those with access to your local network (i.e. those logged in to your machine), without any further authenication, allowing them to do absolutely anything. Think and make sure that you know what you are doing.
"
Class {
	#name : #ConsoleTelnetServer,
	#superclass : #ConsoleLogic,
	#instVars : [
		'port',
		'process',
		'serverSocket'
	],
	#category : #'Console-Core'
}

{ #category : #public }
ConsoleTelnetServer class >> startOn: port [
	"self startOn: 4999"
	
	^ self new
		port: port;
		start
]

{ #category : #protocol }
ConsoleTelnetServer >> executeRequestResponseLoopOn: stream [

	| in out command executeResult |
	in := ZnCharacterReadStream on: stream.
	out := ZnCharacterWriteStream on: stream.
	self writeLine: ('Console ', SystemVersion current asString) to: out.
	[
		stream nextPutAll: 'pharo>>> '; flush.
		command := (self readInputFrom: in).
		executeResult := [ command execute ] 
			on: Error 
			do: [ :exception | command printString, ' failed with ', exception printString ].
		self writeOutput: command result to: out.
		executeResult notNil	] whileTrue
]

{ #category : #private }
ConsoleTelnetServer >> initializeServerSocket [
	serverSocket := Socket newTCP.
	serverSocket setOption: 'TCP_NODELAY' value: 1.
	serverSocket 
		listenOn: self port 
		backlogSize: 10 
		interface: NetNameResolver loopBackAddress.
	serverSocket isValid
		ifFalse: [ self error: 'Cannot create socket on port ' , self port printString ]
]

{ #category : #testing }
ConsoleTelnetServer >> isRunning [
	"Return true when I am running"
	
	^ process notNil and: [ serverSocket notNil ]
]

{ #category : #protocol }
ConsoleTelnetServer >> listenLoop [
	"We create a listening Socket, then wait for a connection.
	After each connection we also check that the listening Socket is still valid 
	- if not we just make a recursive call to this method to start over."

	self initializeServerSocket.
	[ [ 
		serverSocket isValid 
			ifFalse: [
				"will trigger #ifCurtailed: block and destroy socket"
				^ self listenLoop ].
		self serveConnectionsOn: serverSocket ] repeat ]

		ifCurtailed: [ self releaseServerSocket ]
]

{ #category : #accessing }
ConsoleTelnetServer >> port [
	^ port ifNil: [ port := 4999 ]
]

{ #category : #accessing }
ConsoleTelnetServer >> port: integer [
	port := integer
]

{ #category : #printing }
ConsoleTelnetServer >> printOn: stream [
	super printOn: stream.
	stream << $(.
	self isRunning ifTrue: [ stream << #running; space; print: self port ].
	stream << $)
]

{ #category : #private }
ConsoleTelnetServer >> releaseServerSocket [
	(Delay forMilliseconds: 10) wait.
	serverSocket destroy.
	serverSocket := nil
]

{ #category : #protocol }
ConsoleTelnetServer >> serveConnectionsOn: listeningSocket [
	"We wait up to acceptWaitTimeout seconds for an incoming connection.
	If we get one we wrap it in a SocketStream and #executeRequestResponseLoopOn: on it"
		 
	| stream socket |
	socket := listeningSocket waitForAcceptFor: 300.
	socket ifNil: [ ^ self ].
	stream := self socketStreamOn: socket.
	[ [ [ self executeRequestResponseLoopOn: stream ]
		ensure: [ [ stream close ] on: Exception do: [ ] ] ]
			ifCurtailed: [ socket destroy ] ]
				forkAt: Processor lowIOPriority
				named: self workerProcessName 
]

{ #category : #accessing }
ConsoleTelnetServer >> serverProcessName [
	^ self class name asString , ' port ' , self port asString
]

{ #category : #private }
ConsoleTelnetServer >> socketStreamOn: socket [
	^ (ZdcSocketStream on: socket)
		binary;
		shouldSignal: true;
		autoFlush: false;
		timeout: self timeout;
		yourself
]

{ #category : #public }
ConsoleTelnetServer >> start [
	self stop.
	process := [ [ self listenLoop ] repeat ] 
					forkAt: Processor highIOPriority 
					named: self serverProcessName
]

{ #category : #public }
ConsoleTelnetServer >> stop [
	self isRunning ifFalse: [ ^ self ].
	process terminate. 
	process := nil.

]

{ #category : #accessing }
ConsoleTelnetServer >> timeout [
	^ 60
]

{ #category : #accessing }
ConsoleTelnetServer >> workerProcessName [
	^ self serverProcessName, ' Connection Handler'
]

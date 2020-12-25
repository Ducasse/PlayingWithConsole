Class {
	#name : #ConsoleLogic,
	#superclass : #Object,
	#category : #'Console-Core'
}

{ #category : #protocol }
ConsoleLogic >> exceptionClasses [ 

	^ ConnectionClosed, ConnectionTimedOut 
]

{ #category : #protocol }
ConsoleLogic >> writeLine: string to: stream [
	stream nextPutAll: string; lf; flush
]

{ #category : #protocol }
ConsoleLogic >> writeOutput: string to: stream [
	string lines
		do: [ :each | stream nextPutAll: each ]
		separatedBy: [ stream lf ].
	stream lf; flush
]

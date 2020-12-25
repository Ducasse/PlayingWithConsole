"
Get the value of a metric (gauge or counter)

get - list all metrics
get <metric> - show the current value of <metric>

Examples

get

- list all existing metrics

get system.status

- show the result of a specific metric

get system.*

- list all metrics starting with system.

get status

- list all metrics containing 'status'
"
Class {
	#name : #ConsoleGetCommand,
	#superclass : #ConsoleCommand,
	#category : #'Console-Core'
}

{ #category : #accessing }
ConsoleGetCommand class >> defaultName [
	^ 'get'
]

{ #category : #public }
ConsoleGetCommand >> execute [
	self hasArguments 
		ifTrue: [ 
			[ result := (ConsoleMetric named: self argument) value asString ] 
				on: NotFound 
				do: [ :exception | 
					result := (ConsoleMetric matching: self argument)
						ifEmpty: [ exception printString ]
						ifNotEmpty: [ :matchingMetrics |
							String streamContents: [ :out |
								out << 'matching metrics:'; cr.
								self renderMetrics: matchingMetrics on: out ] ] ] ]
		ifFalse: [ 
			result := String streamContents: [ :out |
				out << 'known metrics:'; cr.
				self renderMetrics: ConsoleMetric knownMetrics on: out ] ]
]

{ #category : #'initialization-release' }
ConsoleGetCommand >> on: input [
	super on: input.
	arguments := self argument findTokens: Character separators.
	arguments := arguments allButFirst 
]

{ #category : #private }
ConsoleGetCommand >> renderMetrics: metrics on: out [
	(metrics sorted: #name ascending)
		do: [ :each | out space; space; << each name; << ' - '; << each description ] 
		separatedBy: [ out cr ]
]

"
I am NeoConsoleMetric. I represent a named metric with a description. I evaluate my reader to access my actual value.

My class side holds a list of #knownMetrics.
"
Class {
	#name : #ConsoleMetric,
	#superclass : #Object,
	#instVars : [
		'name',
		'description',
		'reader'
	],
	#classVars : [
		'KnownMetrics'
	],
	#category : #'Console-Core'
}

{ #category : #accessing }
ConsoleMetric class >> add: metric [
	^ self knownMetrics 
		removeAllSuchThat: [ :each | each name = metric name ]; 
		add: metric
]

{ #category : #accessing }
ConsoleMetric class >> addNamed: metricName description: description reader: valueable [
	^ self add: (self named: metricName description: description reader: valueable)
]

{ #category : #initialization }
ConsoleMetric class >> initialize [
	"self initialize"
	
	KnownMetrics := nil.
	self initializeMetrics.
	
	"last update: 2015-08-17"
]

{ #category : #initialization }
ConsoleMetric class >> initializeChronologyMetrics [
	self addNamed: 'system.uptime' 
		description: 'Image uptime human readeable' 
		reader: [ (self sessionAge roundTo: 1 minute) humanReadablePrintString ].	
	self addNamed: 'system.uptimeseconds' 
		description: 'Image uptime seconds' 
		reader: [ self sessionAge asSeconds ].	
	self addNamed: 'system.date' 
		description: 'Current date' 
		reader: [ Date today printString ].
	self addNamed: 'system.time'
		description: 'Current time'
		reader: [ Time now printString ].
	self addNamed: 'system.timestamp'
		description: 'Current timestamp'
		reader: [ DateAndTime now printString ].
]

{ #category : #initialization }
ConsoleMetric class >> initializeMemoryMetrics [
	self addNamed: 'memory.total' 
		description: 'Total allocated memory' 
		reader: [ self memoryTotal ].
	self addNamed: 'memory.free'
		description: 'Free memory'
		reader: [ self memoryFree ].
	self addNamed: 'memory.gc'
		description: 'Garbage collect, return free memory'
		reader: [ Smalltalk garbageCollect. self memoryFree ].
]

{ #category : #initialization }
ConsoleMetric class >> initializeMetrics [
	self initializeSystemStatusMetric.
	self initializeMemoryMetrics.
	self initializeChronologyMetrics.
	self initializeProcessMetrics.
	self initializeVersionMetrics.
]

{ #category : #initialization }
ConsoleMetric class >> initializeProcessMetrics [
	self addNamed: 'process.count' 
		description: 'Current process count' 
		reader: [ (Process allSubInstances reject: #isTerminated) size asString ].
	self addNamed: 'process.list'
		description: 'Current list of processes'
		reader: [ String cr join: ((Process allSubInstances reject: #isTerminated) collect: #name as: Array) ].
]

{ #category : #initialization }
ConsoleMetric class >> initializeSystemStatusMetric [
	self addNamed: 'system.status' 
		description: 'Simple system status' 
		reader: [
			'Status OK - Clock {1} - Allocated {2} bytes - {3} % free.' format: { 
				DateAndTime now.
				self memoryTotal asStringWithCommas. 
				(self memoryFree / self memoryTotal * 100.0) printShowingDecimalPlaces: 2 } ]
]

{ #category : #initialization }
ConsoleMetric class >> initializeVersionMetrics [
	self addNamed: 'system.version' 
		description: 'Image version info' 
		reader: [ SystemVersion current ].
	self addNamed: 'system.mcversions' 
		description: 'Monticello packages version info' 
		reader: [ String cr join: (MCWorkingCopy allManagers collect: #description) sorted ].
]

{ #category : #accessing }
ConsoleMetric class >> knownMetrics [
	^ KnownMetrics ifNil: [ KnownMetrics := OrderedCollection new ]
]

{ #category : #accessing }
ConsoleMetric class >> matching: pattern [
	| patternToSearchFor |
	patternToSearchFor := (pattern includes: $*) ifTrue: [ pattern ] ifFalse: [ '*' , pattern , '*' ]. 
	^ self knownMetrics select: [ :each | patternToSearchFor match: each name ]
]

{ #category : #private }
ConsoleMetric class >> memoryFree [
	^ self memoryTotal - Smalltalk vm youngSpaceEnd
]

{ #category : #private }
ConsoleMetric class >> memoryTotal [
	^ Smalltalk vm memoryEnd
]

{ #category : #accessing }
ConsoleMetric class >> named: metricName [
	^ self knownMetrics detect: [ :each | each name = metricName ] ifNone: [ NotFound signalFor: metricName ]
]

{ #category : #'instance creation' }
ConsoleMetric class >> named: metricName description: description reader: valueable [
	^ self new
		name: metricName;
		description: description;
		reader: valueable;
		yourself
]

{ #category : #private }
ConsoleMetric class >> sessionAge [
	^ (Smalltalk globals includesKey: #Session)
		ifTrue: [ (Smalltalk globals at: #Session) current age ]
		ifFalse: [ DateAndTime now - (Smalltalk globals at: #SessionManager) default currentSession creationTime ]
]

{ #category : #'system startup' }
ConsoleMetric class >> startUp [
	"This message is sent to registered classes when the system is coming up."
	
	self initialize 
 
]

{ #category : #accessing }
ConsoleMetric >> description [
	^ description
]

{ #category : #accessing }
ConsoleMetric >> description: string [
	description := string
]

{ #category : #accessing }
ConsoleMetric >> name [
	^ name
]

{ #category : #accessing }
ConsoleMetric >> name: string [
	name := string
]

{ #category : #printing }
ConsoleMetric >> printOn: stream [
	super printOn: stream.
	stream nextPut: $(; << name; nextPut: $)
]

{ #category : #accessing }
ConsoleMetric >> reader [
	^ reader
]

{ #category : #accessing }
ConsoleMetric >> reader: aValuable [
	reader := aValuable
]

{ #category : #accessing }
ConsoleMetric >> value [
	^ reader value
]

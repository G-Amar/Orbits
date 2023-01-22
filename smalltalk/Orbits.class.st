"
I represent an Orbit. I take a string and create an association between planets. Inputing the names of 2 planets will calculate and show the distance between them. Inputing a single planet will show information about that planet.
 
   Instance Variables
	planets:		A dictionary of planet objects.
"
Class {
	#name : #Orbits,
	#superclass : #Object,
	#instVars : [
		'planets'
	],
	#category : #'CPS506-A1'
}

{ #category : #'instance creation' }
Orbits class >> from: aString [

	^ self new from: aString
]

{ #category : #'as yet unclassified' }
Orbits >> calculateDistance: words [

	| str planet1 planet2 planet1Path parent dist |
	planet1 := words at: 1.
	planet2 := words at: 2.
	planet1Path := self pathToRoot: planet1.
	parent := self findCommonParent: planet2 in: planet1Path.
	dist := (self distanceFrom: planet1 to: parent)
	        + (self distanceFrom: planet2 to: parent).
	str := 'From ' , planet1 , ' to ' , planet2 , ' is ' , dist asString , 'km'.
	^ str
]

{ #category : #'as yet unclassified' }
Orbits >> distanceFrom: planetString to: parentString [

	| distance trav |
	distance := 0.
	trav := planets at: planetString.
	[ trav getName ~= parentString ] whileTrue: [ 
		distance := distance + trav getDistance asInteger .
		trav := planets at: trav getParent ].
	^ distance
]

{ #category : #'as yet unclassified' }
Orbits >> findCommonParent: planetString in: path [

	| trav |
	trav := planets at: planetString ifAbsent: [ ^ nil ].
	[ trav isNotNil ] whileTrue: [ 
		(path includes: trav getName) ifTrue: [ ^ trav getName ].
		trav := planets at: trav getParent ]
]

{ #category : #'instance creation' }
Orbits >> from: input [

	| result lines words wordCount |
	result := ''.
	lines := self parseInput: input.

	lines do: [ :line | 
		line isNotEmpty ifTrue: [ "ignore line if empty"
			words := self parseLine: line.
			wordCount := words size.
			wordCount = 1 ifTrue: [ 
				result := result , (self planetDetails: words) , String cr ].
			wordCount = 2 ifTrue: [ 
				result := result , (self calculateDistance: words) , String cr ].
			wordCount = 3 ifTrue: [ self storeDistance: words ] ] ].

	^ result "keep trailing newline"
]

{ #category : #parsing }
Orbits >> getPlanets [

	^ planets 
]

{ #category : #parsing }
Orbits >> parseInput: input [

	^ input substrings: String cr
]

{ #category : #parsing }
Orbits >> parseLine: line [

	^ line substrings
]

{ #category : #'as yet unclassified' }
Orbits >> pathToRoot: planetString [

	| path trav |
	path := OrderedCollection new.
	trav := planets at: planetString ifAbsent: [ ^ nil ].
	[ trav getParent isNotNil ] whileTrue: [ 
		path add: trav getName.
		trav := planets at: trav getParent ].
	path add: trav getName. "adds root planet"

	^ path
]

{ #category : #'as yet unclassified' }
Orbits >> planetDetails: words [

	| str planetString chain |
	planetString := words at: 1.
	(planets at: planetString) getParent ifNil: [ ^ '' ].
	str := planetString , ' orbits '.
	chain := self pathToRoot: planetString.
	2 to: chain size do: [ :i | str := str , (chain at: i) , ' ' ].
	^ str trimRight
]

{ #category : #'as yet unclassified' }
Orbits >> storeDistance: words [

	"words = [parent , distance, child]"

	| dist child parent parentString childString |
	planets ifNil: [ planets := Dictionary new ].
	parentString := words at: 1.
	dist := words at: 2.
	childString := words at: 3.
	"get child or create new child in dictionary"
	child := planets
		         at: childString
		         ifAbsentPut: [ Planet new setName: childString ].
	child setParent: parentString.
	child setDistance: dist.
	"similarly for parent"
	parent := planets
		          at: parentString
		          ifAbsentPut: [ Planet new setName: parentString ].
	parent addChild: childString
]

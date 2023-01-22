"
I represent a planet.

Note: Although the children instance variable is not used in the program to calculate distance, it is still implemented and left here for completeness.

    Instance Variables
	children:		List of planets that orbit me.
	distance:		The distance at which I orbit my parent planet.
	name:		   My name.
	parent:		The name of the planet I orbit.
"
Class {
	#name : #Planet,
	#superclass : #Object,
	#instVars : [
		'name',
		'parent',
		'children',
		'distance'
	],
	#category : #'CPS506-A1'
}

{ #category : #setter }
Planet >> addChild: childString [

	children add: childString
]

{ #category : #setter }
Planet >> checkEqual: otherPlanet [

	name = otherPlanet getName ifFalse: [ ^ false ].
	parent = otherPlanet getParent ifFalse: [ ^ false ].
	children = otherPlanet getChildren ifFalse: [ ^ false ].
	distance = otherPlanet getDistance ifFalse: [ ^ false ].
	^ true
]

{ #category : #accessing }
Planet >> getChildren [

	^ children
]

{ #category : #accessing }
Planet >> getDistance [

	^ distance
]

{ #category : #accessing }
Planet >> getName [

	^ name
]

{ #category : #accessing }
Planet >> getParent [

	^ parent 
]

{ #category : #initialization }
Planet >> initialize [

	super initialize.
	children := LinkedList new
]

{ #category : #setter }
Planet >> setDistance: int [

	distance ifNil: [ distance := int ]
]

{ #category : #setter }
Planet >> setName: nameString [

	name ifNil: [ name := nameString ]
]

{ #category : #setter }
Planet >> setParent: parentString [

	parent ifNil: [ parent := parentString ]
]

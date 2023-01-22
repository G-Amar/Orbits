Class {
	#name : #PlanetTest,
	#superclass : #TestCase,
	#category : #'CPS506-A1-Tests'
}

{ #category : #tests }
PlanetTest >> testGetSet [

	| planet |
	planet := Planet new.
	planet setName: 'Mars'.
	planet setParent: 'Sun'.
	planet setDistance: 227943824.
	planet addChild: 'Phobos'.
	planet addChild: 'Deimos'.
	
self assert: (planet getName) equals: 'Mars'.
self assert: (planet getParent) equals: 'Sun'.
self assert: (planet getDistance) equals: 227943824.
self assert: (planet getChildren) equals: (LinkedList with: 'Phobos' with: 'Deimos').
]

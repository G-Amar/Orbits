Class {
	#name : #OrbitsTest,
	#superclass : #TestCase,
	#instVars : [
		'orbits'
	],
	#category : #'CPS506-A1-Tests'
}

{ #category : #tests }
OrbitsTest class >> solarSystem [

	" Data from https://space-facts.com/ "

	^ 'Sun 57909227 Mercury
Sun 149598262 Earth
Earth 384400 Moon
Moon 1757 LROrbiter
Mars 9376 Phobos
Mars 23458 Deimos
Sun 227943824 Mars
Sun 778340821 Jupiter
Sun 1426666422 Saturn
Sun 2870658186 Uranus
Sun 4498396441 Neptune
'
]

{ #category : #running }
OrbitsTest >> setUp [

	super setUp.
	orbits := Orbits new
		          from: self solarSystem;
		          yourself
]

{ #category : #tests }
OrbitsTest >> solarSystem [
	^ self class solarSystem
]

{ #category : #'as yet unclassified' }
OrbitsTest >> testDistanceCalcs [

	| o |
	o := Orbits new.
	o from: 'Sun 57909227 Mercury
Sun 149598262 Earth
Earth 384400 Moon
Moon 1757 LROrbiter
Mars 9376 Phobos
Mars 23458 Deimos
Sun 227943824 Mars
Sun 778340821 Jupiter
Sun 1426666422 Saturn
Sun 2870658186 Uranus
Sun 4498396441 Neptune
'.
	"distanceFrom:to: only calculates along path"
	self assert: (o distanceFrom: 'Sun' to: 'Sun') equals: 0.
	self assert: (o distanceFrom: 'Moon' to: 'Sun') equals: 149982662.
	self
		assert: (o distanceFrom: 'LROrbiter' to: 'Sun')
		equals: 149984419.

	"calculateDistance returns string that contains the distance"
	self
		assert: (o calculateDistance: #( 'Phobos' 'Deimos' ))
		equals: 'From Phobos to Deimos is 32834km'.
	self
		assert: (o calculateDistance: #( 'Moon' 'Phobos' ))
		equals: 'From Moon to Phobos is 377935862km'.
	self
		assert: (o calculateDistance: #( 'Sun' 'Moon' ))
		equals: 'From Sun to Moon is 149982662km'.
	self
		assert: (o calculateDistance: #( 'Moon' 'Sun' ))
		equals: 'From Moon to Sun is 149982662km'.
	self
		assert: (o calculateDistance: #( 'LROrbiter' 'Moon' ))
		equals: 'From LROrbiter to Moon is 1757km'.
	self
		assert: (o calculateDistance: #( 'Moon' 'LROrbiter' ))
		equals: 'From Moon to LROrbiter is 1757km'.
	self
		assert: (o calculateDistance: #( 'Moon' 'Moon' ))
		equals: 'From Moon to Moon is 0km'.
	self
		assert: (o calculateDistance: #( 'Sun' 'Sun' ))
		equals: 'From Sun to Sun is 0km'
]

{ #category : #tests }
OrbitsTest >> testLineParse [

	self assert: (Orbits new parseLine: '') equals: #(  ).
	self
		assert: (Orbits new parseLine: 'Sun 57909227 Mercury')
		equals:
		(#('Sun' '57909227' 'Mercury')).
	self
		assert: (Orbits new parseLine: 'Sun Mercury')
		equals: #('Sun' 'Mercury').
	self
		assert: (Orbits new parseLine: 'Mercury')
		equals: #('Mercury')
]

{ #category : #tests }
OrbitsTest >> testParse [

	self
		assert: (Orbits new parseInput: '')
		equals: #().

	self
		assert: (Orbits new parseInput: 'Sun 57909227 Mercury
Sun 149598262 Earth
Earth 384400 Moon
Moon 1757 LROrbiter
Mars 9376 Phobos
Mars 23458 Deimos
Sun 227943824 Mars
Sun 778340821 Jupiter
Sun 1426666422 Saturn
Sun 2870658186 Uranus
Sun 4498396441 Neptune
')
		equals: #('Sun 57909227 Mercury' 'Sun 149598262 Earth' 'Earth 384400 Moon' 'Moon 1757 LROrbiter' 'Mars 9376 Phobos' 'Mars 23458 Deimos' 'Sun 227943824 Mars' 'Sun 778340821 Jupiter' 'Sun 1426666422 Saturn' 'Sun 2870658186 Uranus' 'Sun 4498396441 Neptune').
]

{ #category : #'as yet unclassified' }
OrbitsTest >> testPath [

	| o |
	o := Orbits new.
	o from: 'Sun 57909227 Mercury
Sun 149598262 Earth
Earth 384400 Moon
Moon 1757 LROrbiter
Mars 9376 Phobos
Mars 23458 Deimos
Sun 227943824 Mars
Sun 778340821 Jupiter
Sun 1426666422 Saturn
Sun 2870658186 Uranus
Sun 4498396441 Neptune
'.
	self
		assert: (o pathToRoot: 'Sun')
		equals: (OrderedCollection with: 'Sun').

	self
		assert: (o planetDetails: #( 'Earth' ))
		equals: 'Earth orbits Sun'.

	self assert: (o pathToRoot: 'LROrbiter') equals: (OrderedCollection
			 with: 'LROrbiter'
			 with: 'Moon'
			 with: 'Earth'
			 with: 'Sun').

	self
		assert: (o planetDetails: #( 'LROrbiter' ))
		equals: 'LROrbiter orbits Moon Earth Sun'.

	"findCommonParent tests"
	self
		assert:
		(o findCommonParent: 'Deimos' in: (o pathToRoot: 'LROrbiter'))
		equals: 'Sun'.
	self
		assert:
		(o findCommonParent: 'LROrbiter' in: (o pathToRoot: 'Deimos'))
		equals: 'Sun'.
	self
		assert: (o findCommonParent: 'Deimos' in: (o pathToRoot: 'Mars'))
		equals: 'Mars'.
	self
		assert:
		(o findCommonParent: 'Deimos' in: (o pathToRoot: 'Deimos'))
		equals: 'Deimos'
]

{ #category : #'as yet unclassified' }
OrbitsTest >> testPlanetDetails [

	| o |
	o := Orbits new.
	o from: 'Sun 57909227 Mercury
Sun 149598262 Earth
Earth 384400 Moon
Moon 1757 LROrbiter
Mars 9376 Phobos
Mars 23458 Deimos
Sun 227943824 Mars
Sun 778340821 Jupiter
Sun 1426666422 Saturn
Sun 2870658186 Uranus
Sun 4498396441 Neptune
'.

	self assert: (o planetDetails: #( 'Sun' )) equals: ''.
	self assert: (o planetDetails: #( 'Moon' )) equals: 'Moon orbits Earth Sun'.
	self assert: (o planetDetails: #( 'LROrbiter' )) equals: 'LROrbiter orbits Moon Earth Sun'.
	self assert: (o planetDetails: #( 'Phobos' )) equals: 'Phobos orbits Mars Sun'.
	self assert: (o planetDetails: #( 'Mercury' )) equals: 'Mercury orbits Sun'.
]

{ #category : #tests }
OrbitsTest >> testStoreDistance [

	| o dict p |
	o := Orbits new.
	o storeDistance: #( 'Sun' 57909227 'Mercury' ).
	o storeDistance: #( 'Sun' 149598262 'Earth' ).
	o storeDistance: #( 'Earth' 384400 'Moon' ).
	dict := o getPlanets.

	p := Planet new.
	p setName: 'Mercury'.
	p setParent: 'Sun'.
	p setDistance: 57909227.
	self assert: ((dict at: 'Mercury') checkEqual: p) equals: true.

	p := Planet new.
	p setName: 'Sun'.
	p addChild: 'Mercury'.
	p addChild: 'Earth'.
	self assert: ((dict at: 'Sun') checkEqual: p) equals: true.

	p := Planet new.
	p setName: 'Earth'.
	p setParent: 'Sun'.
	p setDistance: 149598262.
	p addChild: 'Moon'.
	self assert: ((dict at: 'Earth') checkEqual: p) equals: true.
	
p := Planet new.
	p setName: 'Moon'.
	p setParent: 'Earth'.
	p setDistance: 384400.
	self assert: ((dict at: 'Moon') checkEqual: p) equals: true
]

{ #category : #tests }
OrbitsTest >> testString [

	self
		assert: (Orbits from: self solarSystem , 'Sun Moon
Deimos Moon
Deimos
Moon
LROrbiter
')
		equals: 'From Sun to Moon is 149982662km
From Deimos to Moon is 377949944km
Deimos orbits Mars Sun
Moon orbits Earth Sun
LROrbiter orbits Moon Earth Sun
'
]

{ #category : #'as yet unclassified' }
OrbitsTest >> testinit [

	"Ensures that initializing from class and instance is same"

	self
		assert: (Orbits new from: self solarSystem , 'Sun Moon
Deimos Moon
Deimos
Moon
LROrbiter
')
		equals: (Orbits from: self solarSystem , 'Sun Moon
Deimos Moon
Deimos
Moon
LROrbiter
')
]

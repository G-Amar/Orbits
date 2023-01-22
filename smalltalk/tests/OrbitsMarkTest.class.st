Class {
	#name : #OrbitsMarkTest,
	#superclass : #TestCase,
	#instVars : [
		'orbits'
	],
	#category : #'CPS506-A1-Tests'
}

{ #category : #tests }
OrbitsMarkTest class >> altSystem [

	" Data from https://space-facts.com/ "

	^ 'MilkyWay 10000000000 Sun
MilkyWay 15000000000 AlphaCenturi
AlphaCenturi 100000000 EarthLike
Sun 57909227 Mercury
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

{ #category : #tests }
OrbitsMarkTest class >> solarSystem [

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
OrbitsMarkTest >> altSystem [

	^ self class altSystem
]

{ #category : #running }
OrbitsMarkTest >> setUp [

	super setUp.
	orbits := Orbits new
		          from: self solarSystem;
		          yourself
]

{ #category : #running }
OrbitsMarkTest >> solarSystem [
	^ self class solarSystem
]

{ #category : #'tests-orbits' }
OrbitsMarkTest >> testEarth [

	self
		assert: (Orbits from: self solarSystem , 'Earth
')
		equals: 'Earth orbits Sun
'
]

{ #category : #'tests-orbits' }
OrbitsMarkTest >> testEarthAlt [

	self
		assert: (Orbits from: self altSystem , 'Earth
')
		equals: 'Earth orbits Sun MilkyWay
'
]

{ #category : #'tests-distance' }
OrbitsMarkTest >> testEarthEarth [

	self
		assert: (Orbits from: self solarSystem , 'Earth Earth
')
		equals: 'From Earth to Earth is 0km
'
]

{ #category : #'tests-distance' }
OrbitsMarkTest >> testEarthEarthAlt [

	self
		assert: (Orbits from: self altSystem , 'Earth Earth
')
		equals: 'From Earth to Earth is 0km
'
]

{ #category : #'tests-distance' }
OrbitsMarkTest >> testEarthEarthLike [

	self
		assert: (Orbits from: self altSystem , 'Earth EarthLike
')
		equals: 'From Earth to EarthLike is 25249598262km
'
]

{ #category : #'tests-orbits' }
OrbitsMarkTest >> testEarthLike [

	self
		assert: (Orbits from: self altSystem , 'EarthLike
')
		equals: 'EarthLike orbits AlphaCenturi MilkyWay
'
]

{ #category : #'tests-distance' }
OrbitsMarkTest >> testEarthSun [

	self
		assert: (Orbits from: self solarSystem , 'Earth Sun
')
		equals: 'From Earth to Sun is 149598262km
'
]

{ #category : #'tests-distance' }
OrbitsMarkTest >> testGivenExample [

	self
		assert: (Orbits from: self solarSystem , 'Sun Moon
Deimos Moon
Deimos
Deimos Phobos
Moon
LROrbiter
Sun
')
		equals: 'From Sun to Moon is 149982662km
From Deimos to Moon is 377949944km
Deimos orbits Mars Sun
From Deimos to Phobos is 32834km
Moon orbits Earth Sun
LROrbiter orbits Moon Earth Sun
Sun orbits
'
]

{ #category : #'tests-orbits' }
OrbitsMarkTest >> testLROrbiter [

	self
		assert: (Orbits from: self solarSystem , 'LROrbiter
Sun
')
		equals: 'LROrbiter orbits Moon Earth Sun
Sun orbits
'
]

{ #category : #'tests-distance' }
OrbitsMarkTest >> testMoonDeimos [

	self
		assert: (Orbits from: self solarSystem , 'Moon Deimos
')
		equals: 'From Moon to Deimos is 377949944km
'
]

{ #category : #'tests-distance' }
OrbitsMarkTest >> testPhobosDeimos [

	self
		assert: (Orbits from: self solarSystem , 'Phobos Deimos
')
		equals: 'From Phobos to Deimos is 32834km
'
]

{ #category : #'tests-orbits' }
OrbitsMarkTest >> testSun [

	self
		assert: (Orbits from: self solarSystem , 'Sun
')
		equals: 'Sun orbits
'
]

{ #category : #'tests-distance' }
OrbitsMarkTest >> testSunEarth [

	self
		assert: (Orbits from: self solarSystem , 'Sun Earth
')
		equals: 'From Sun to Earth is 149598262km
'
]

{ #category : #'tests-distance' }
OrbitsMarkTest >> testSunEarthLike [

	self
		assert: (Orbits from: self altSystem , 'Sun EarthLike
')
		equals: 'From Sun to EarthLike is 25100000000km
'
]

{ #category : #'tests-distance' }
OrbitsMarkTest >> testSunSun [

	self
		assert: (Orbits from: self solarSystem , 'Sun Sun
')
		equals: 'From Sun to Sun is 0km
'
]

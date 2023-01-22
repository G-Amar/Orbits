defmodule A2Test do
  use ExUnit.Case
  doctest A2

  def solarSystem do
"Sun 57909227 Mercury
Earth 384400 Moon
Sun 149598262 Earth
Moon 1757 LROrbiter
Mars 9376 Phobos
Mars 23458 Deimos
Sun 227943824 Mars
Sun 778340821 Jupiter
Sun 1426666422 Saturn
Sun 2870658186 Uranus
Sun 4498396441 Neptune
"
  end

  test "default example" do
    assert solarSystem() <>
  "Sun Moon
Deimos Moon
Deimos
Deimos Phobos
Moon
LROrbiter
" |> A2.process() == "From Sun to Moon is 149982662km
From Deimos to Moon is 377949944km
Deimos orbits Mars Sun
From Deimos to Phobos is 32834km
Moon orbits Earth Sun
LROrbiter orbits Moon Earth Sun
"
  end

  test "splitlines" do
    assert solarSystem() |> A2.getlines() ==
      ["Sun 57909227 Mercury",
       "Earth 384400 Moon",
       "Sun 149598262 Earth",
       "Moon 1757 LROrbiter",
       "Mars 9376 Phobos",
       "Mars 23458 Deimos",
       "Sun 227943824 Mars",
       "Sun 778340821 Jupiter",
       "Sun 1426666422 Saturn",
       "Sun 2870658186 Uranus",
       "Sun 4498396441 Neptune"]
  end

  test "getwords" do
    assert solarSystem() <> "Sun Moon
Deimos Moon
Deimos
Deimos Phobos
Moon
LROrbiter
" |> A2.getlines() |> A2.getwords() ==
      [["Sun", "57909227", "Mercury"],
       ["Earth", "384400", "Moon"],
       ["Sun", "149598262", "Earth"],
       ["Moon", "1757", "LROrbiter"],
       ["Mars", "9376", "Phobos"],
       ["Mars", "23458", "Deimos"],
       ["Sun", "227943824", "Mars"],
       ["Sun", "778340821", "Jupiter"],
       ["Sun", "1426666422", "Saturn"],
       ["Sun", "2870658186", "Uranus"],
       ["Sun", "4498396441", "Neptune"],
       ["Sun","Moon"],
       ["Deimos","Moon"],
       ["Deimos"],
       ["Deimos","Phobos"],
       ["Moon"],
       ["LROrbiter"],]
  end

  test "planetinfo" do
    assert solarSystem() <>
  "Sun
Deimos
Moon
LROrbiter
Earth
Phobos
" |> A2.process() == "
Deimos orbits Mars Sun
Moon orbits Earth Sun
LROrbiter orbits Moon Earth Sun
Earth orbits Sun
Phobos orbits Mars Sun
"
  end

  test "longer example" do
    assert solarSystem() <>
  "Phobos Deimos
  Moon Phobos
  Sun Moon
  Moon Sun
  LROrbiter Moon
  Moon LROrbiter
  Moon Moon
  Sun Sun
  Moon
  Sun
  Mercury
  LROrbiter
  Neptune

" |> A2.process() == "From Phobos to Deimos is 32834km
From Moon to Phobos is 377935862km
From Sun to Moon is 149982662km
From Moon to Sun is 149982662km
From LROrbiter to Moon is 1757km
From Moon to LROrbiter is 1757km
From Moon to Moon is 0km
From Sun to Sun is 0km
Moon orbits Earth Sun

Mercury orbits Sun
LROrbiter orbits Moon Earth Sun
Neptune orbits Sun
"
  end
end

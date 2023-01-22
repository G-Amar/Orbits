defmodule A2 do
  @moduledoc """
  Documentation for `A2`.
  """

  @doc """
  Assignment 2 - Orbits

  """
  def getlines(str) do String.split(str, "\n", trim: true) end

  def getwords(list) do Enum.map(list, &(String.split(&1, " ", trim: true))) end

  #planets are stored in map form: planet => {parent, distance from parent}
  def storeplanets(parent, d, child, planets) do
    planets = Map.put(planets, child, {parent, d}) #add/update child in dict
    unless Map.get(planets, parent) do
      Map.put(planets, parent, {nil, 0}) #add parent to dict if not there and return
    else
      planets
    end
  end

  def planetinfo(planet, planets) do
    unless Map.get(planets, planet) |> elem(0) do #ensure planet is not root, nil is false
      "\n" #return empty line if planet is root
    else
      chain = pathtoroot(planet, planets)
      "#{planet} orbits#{pathstring(chain)}\n"
    end
  end

  def pathtoroot(planet, planets) do
    pathtoroot(planet, planets, [])
  end
  defp pathtoroot(nil, _, chain) do chain end
  defp pathtoroot(planet, planets, chain) do
    pathtoroot(Map.get(planets, planet) |> elem(0), planets, chain ++ [planet])
  end

  def pathstring(list) do
    pathstring(tl(list), "") #start from 2nd element because 1st is planet itself
  end
  defp pathstring([], output) do output end
  defp pathstring([planet|tail], output) do
    pathstring(tail, output <> " #{planet}")
  end

  def calcdistance(planet1, planet2, planets) do
    path = pathtoroot(planet1, planets)
    common = findcommon(path, planet2, planets)
    dist = distancefrom(common, planet1, planets) + distancefrom(common, planet2, planets)
    "From #{planet1} to #{planet2} is #{dist}km\n"
  end

  def findcommon(path, planet, planets) do
    if Enum.any?(path, fn(x) -> x == planet end) do
      planet
    else
      findcommon(path, Map.get(planets, planet) |> elem(0), planets)
    end
  end

  def distancefrom(parent, planet, planets) do
    distancefrom(parent, planet, planets, 0)
  end
  defp distancefrom(parent, planet, _, acc) when parent == planet do acc end
  defp distancefrom(parent, planet, planets, acc) do
    {next, distance} = Map.get(planets, planet)
    distancefrom(parent, next, planets, acc + String.to_integer(distance))
  end

  def parseline(words) do parseline(words, "", %{}) end #initialize result string and map
  defp parseline([], output, _) do output end
  defp parseline([line|tail], output, planets) do #performs actions based on # of words
    case line do
      [parent, d, child] -> parseline(tail, output, storeplanets(parent, d, child, planets))
      [planet1, planet2] -> parseline(tail, output <> calcdistance(planet1, planet2, planets), planets)
      [planet] -> parseline(tail, output <> planetinfo(planet, planets), planets)
      _ -> parseline(tail, output, planets)
    end
  end


  def process(input) do
    lines = getlines(input)
    words = getwords(lines)
    parseline(words)
  end

  def main() do
    IO.read(:stdio, :all)
    |> process()
    |> IO.write()
  end
end

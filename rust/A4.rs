use std::io;
use std::collections::HashMap;

fn add_planets<'a>(parent: &'a str, d: &'a str, child: &'a str, planetlist: &mut HashMap<&'a str, (&'a str, &'a str)>){
  match planetlist.get(parent){
    Some(_) => (),
    None => {planetlist.insert(parent, ("", "0")); ()} //add parent if not there
  }
  planetlist.insert(child, (parent, d));
}

fn planet_info(planet: &str, planetlist: &HashMap<&str, (&str, &str)>) -> String {
  let chain = chain_to_root(planet, &planetlist);
  let mut out = planet.to_string() + " orbits";
  for i in 1..chain.len(){
    out += " ";
    out += chain[i];
  }
  out + "\n"
}

fn chain_to_root <'a> (planet: &'a str, planetlist: &'a HashMap<&'a str, (&'a str, &'a str)>) -> Vec<&'a str>{
  let mut chain = Vec::new();
  let mut trav = planet;
  while trav != "" {
    chain.push(trav);
    match planetlist.get(trav) {
      Some(&(next, _)) => trav = next,
      None => break
    }
  }
  chain
}

fn calculate_distance(planet1: &str, planet2: &str, planetlist: &HashMap<&str, (&str, &str)>) -> String {
  let path = chain_to_root(planet1, &planetlist);
  let common = find_common(&path, planet2, &planetlist);
  let distance = dist_to_root(planet1, common, &planetlist) + dist_to_root(planet2, common, &planetlist);
  format!("From {} to {} is {}km\n", planet1, planet2, distance)
}

fn dist_to_root(planet: &str, common: &str, planetlist: &HashMap<&str, (&str, &str)>) -> i32 {
  let mut trav = planet;
  let mut dist = 0;
  while trav != common {
    match planetlist.get(trav){
      Some(&(next, d)) => {dist += d.to_string().parse::<i32>().unwrap(); trav = next}, //have to use unwrap() here because it returns a Result
      None => return -1
    }
  }
  dist
}

fn find_common <'a> (path: &'a Vec<&'a str>, planet: &'a str, planetlist: &'a HashMap<&'a str, (&'a str, &'a str)>) -> &'a str {
  let mut trav = planet;
  while trav != "" {
    if path.contains(&trav){
      return trav;
    }
    match planetlist.get(trav){
      Some(&(next, _)) => trav = next,
      None => break
    }
  }
  ""
}

fn main(){
  let mut input = String::new();
  loop{
    match io::stdin().read_line(&mut input){
      Ok(0) => break, //EOF
      Ok(_) => (),
      Err(_) => {println!("Error"); return}
    }
  }

  let mut planetlist = HashMap::new();
  let mut output = String::new();

  let input: Vec<&str> = input.split("\n").collect();
  for &line in input.iter(){
    let words: Vec<&str> = line.split_whitespace().collect();
    match words[..]{
      [parent, d, child] => add_planets(parent, d, child, &mut planetlist),
      [planet1, planet2] => output.push_str(&calculate_distance(planet1, planet2, &planetlist)),
      [planet] => output.push_str(&planet_info(planet, &planetlist)),
      _ => ()
    }
  }

  
  print!("{}",output);
}
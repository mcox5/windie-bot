module WindguruLocations
  CODE_LOCATIONS = {
    "pichilemu" => '98',
    "matanzas" => '42511',
    "topocalma" => '42514',
    "puertecillo" => '419841',
    "buchupureo" => '181995'
  }

  def self.code(location_name)
    CODE_LOCATIONS[location_name]
  end
end

extends Resource

class_name Attacker

export (String) var _name
export (int, 1, 999) var max_hp
export (int) var hp
export (int, 1, 999) var max_mp
export (int) var mp
export (int, 1, 100) var attack
export (int, 1, 100) var defense
export (int, 1, 100) var level
export (int) var xp
export (Resource) var sprite_sheet

# At the moment, both Players and Monsters are using this
# same resource.
